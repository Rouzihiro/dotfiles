#!/bin/bash

bluetoothctl <<EOF
power on
agent on
default-agent
trust D0:27:88:6D:8B:81
trust AC:FD:93:0A:E5:AC
scan on
sleep 2
scan off
disconnect D0:27:88:6D:8B:81
disconnect AC:FD:93:0A:E5:AC
connect D0:27:88:6D:8B:81
connect AC:FD:93:0A:E5:AC
quit
EOF

