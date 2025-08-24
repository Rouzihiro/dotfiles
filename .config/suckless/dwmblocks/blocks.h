//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/

  {"󰍛 ", "sh ~/.config/suckless/scripts/cpu.sh", 10, 0},
	{"Mem:", "free -h | awk '/^Mem/ { print $3\"/\"$2 }' | sed s/i//g",	30,		0},
  {"", "sh ~/.config/suckless/scripts/volume.sh", 1, 0},
  {"󰖩  ", "sh ~/.config/suckless/scripts/wifi.sh", 30, 0},
  {"󰂯 ", "sh ~/.config/suckless/scripts/bluetooth.sh", 60, 0},
	{"  ", "date '+%H:%M '", 60, 0},
  {"   ", "echo \"$(cat /sys/class/power_supply/macsmc-battery/capacity)%\"", 15, 0}

};

//sets delimiter between status commands. NULL character ('\0') means no delimiter.
static char delim[] = " | ";
static unsigned int delimLen = 7;
