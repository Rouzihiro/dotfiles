/*
 * battery-notify.c
 *
 * Lightweight Linux battery notification daemon.
 *
 * Features:
 * - Event driven via kernel uevents
 * - Notify every 10% crossing
 * - 80% charging reminder
 * - Low battery sounds
 *
 * Build:
 *   make
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <limits.h>
#include <time.h>
#include <dirent.h>

#include <sys/socket.h>
#include <linux/netlink.h>

#include <libnotify/notify.h>


#define CHARGE_LIMIT 80
#define REPEAT_SECONDS 300


static char battery_path[PATH_MAX];

static int last_level = -1;

static int notified_up[11] = {0};
static int notified_down[11] = {0};

static int charge_notified = 0;

static time_t last_repeat = 0;



static int read_value(const char *file)
{
    char path[PATH_MAX];

    int n = snprintf(
        path,
        sizeof(path),
        "%s/%s",
        battery_path,
        file
    );

    if (n < 0 || (size_t)n >= sizeof(path))
        return -1;


    FILE *fp = fopen(path, "r");

    if (!fp)
        return -1;


    int value = -1;

    fscanf(fp, "%d", &value);

    fclose(fp);

    return value;
}



static void read_status(char *buffer, size_t size)
{
    char path[PATH_MAX];

    int n = snprintf(
        path,
        sizeof(path),
        "%s/status",
        battery_path
    );

    if (n < 0 || (size_t)n >= sizeof(path))
    {
        buffer[0] = '\0';
        return;
    }


    FILE *fp = fopen(path, "r");

    if (!fp)
    {
        buffer[0] = '\0';
        return;
    }


    fgets(buffer, size, fp);

    buffer[strcspn(buffer, "\n")] = '\0';

    fclose(fp);
}



static void play_sound(int level)
{
    char command[PATH_MAX];

    snprintf(
        command,
        sizeof(command),
        "pw-play \"$HOME/assets/sounds/battery%d.oga\" 2>/dev/null",
        level
    );

    system(command);
}



static void send_notification(
    const char *title,
    const char *message,
    NotifyUrgency urgency
)
{
    NotifyNotification *n =
        notify_notification_new(
            title,
            message,
            NULL
        );


    notify_notification_set_urgency(
        n,
        urgency
    );


    notify_notification_show(
        n,
        NULL
    );


    g_object_unref(n);
}



static void notify_battery(int level)
{
    char message[64];

    snprintf(
        message,
        sizeof(message),
        "Battery at %d%%",
        level
    );


    send_notification(
        "Battery",
        message,
        level <= 20
            ? NOTIFY_URGENCY_CRITICAL
            : NOTIFY_URGENCY_NORMAL
    );
}



static void notify_charge(void)
{
    send_notification(
        "Battery",
        "Battery reached 80% - consider unplugging charger.",
        NOTIFY_URGENCY_NORMAL
    );

    play_sound(80);
}



static void find_battery(void)
{
    DIR *dir = opendir(
        "/sys/class/power_supply"
    );


    if (!dir)
        return;


    struct dirent *entry;


    while ((entry = readdir(dir)))
    {
        if (strncmp(entry->d_name, "BAT", 3) == 0)
        {
            snprintf(
                battery_path,
                sizeof(battery_path),
                "/sys/class/power_supply/%s",
                entry->d_name
            );

            break;
        }
    }


    closedir(dir);
}



static void check_thresholds(int level, const char *status)
{
    if (last_level == -1)
    {
        last_level = level;
        return;
    }


    int old_bucket = (last_level / 10) * 10;
    int new_bucket = (level / 10) * 10;


    /*
     * Moving upward (charging)
     */

    if (level > last_level)
    {
        for (
            int b = old_bucket + 10;
            b <= new_bucket;
            b += 10
        )
        {
            if (b <= 100 && !notified_up[b/10])
            {
                notify_battery(b);

                notified_up[b/10] = 1;
            }
        }
    }



    /*
     * Moving downward (discharging)
     */

    if (level < last_level)
    {
        for (
            int b = old_bucket;
            b > new_bucket;
            b -= 10
        )
        {
            if (b > 0 && !notified_down[b/10])
            {
                notify_battery(b);

                notified_down[b/10] = 1;


                if (
                    strcmp(status, "Discharging") == 0 &&
                    b <= 40
                )
                {
                    play_sound(b);
                }
            }
        }
    }


    last_level = level;
}



static void process_battery(void)
{
    int level = read_value("capacity");

    if (level < 0)
        return;


    char status[32];

    read_status(
        status,
        sizeof(status)
    );


    check_thresholds(
        level,
        status
    );


    /*
     * Charging reminder
     */

    if (strcmp(status, "Charging") == 0)
    {
        if (
            level >= CHARGE_LIMIT &&
            !charge_notified
        )
        {
            notify_charge();

            charge_notified = 1;
        }


        if (level < CHARGE_LIMIT)
            charge_notified = 0;
    }



    /*
     * Critical low battery repeat
     */

    if (
        strcmp(status, "Discharging") == 0 &&
        level <= 10
    )
    {
        time_t now = time(NULL);

        if (now - last_repeat >= REPEAT_SECONDS)
        {
            notify_battery(level);

            play_sound(10);

            last_repeat = now;
        }
    }
}



int main(void)
{
    notify_init("battery-notify");


    find_battery();


    int fd = socket(
        PF_NETLINK,
        SOCK_RAW,
        NETLINK_KOBJECT_UEVENT
    );


    if (fd < 0)
    {
        perror("socket");
        return EXIT_FAILURE;
    }


    struct sockaddr_nl addr;

    memset(
        &addr,
        0,
        sizeof(addr)
    );


    addr.nl_family = AF_NETLINK;
    addr.nl_groups = 1;


    if (bind(
        fd,
        (struct sockaddr *)&addr,
        sizeof(addr)
    ) < 0)
    {
        perror("bind");
        return EXIT_FAILURE;
    }


    process_battery();


    char buffer[4096];


    while (1)
    {
        recv(
            fd,
            buffer,
            sizeof(buffer),
            0
        );

        process_battery();
    }


    close(fd);

    return EXIT_SUCCESS;
}
