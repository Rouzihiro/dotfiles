#!/usr/bin/zsh
awk '
/^DTSTART/ {
    dt = $0
    sub(/^DTSTART[^:]*:/, "", dt)
    gsub(/\r/, "", dt)
    if (length(dt) >= 15) {
        date = substr(dt,1,4) "-" substr(dt,5,2) "-" substr(dt,7,2)
        time = substr(dt,10,2) ":" substr(dt,12,2)
    } else {
        date = substr(dt,1,4) "-" substr(dt,5,2) "-" substr(dt,7,2)
        time = "00:00"
    }
}
/^SUMMARY/ {
    summary = $0
    sub(/^SUMMARY:/, "", summary)
    gsub(/\r/, "", summary)
}
/^END:VEVENT/ {
    if (date != "" && summary != "")
        print date " " time "\t" summary "\tnone"
    date = ""; time = ""; summary = ""
}
' "$1"
