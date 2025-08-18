#!/bin/bash

bluetoothctl <<EOF
power on
agent on
default-agent
pair D0:27:88:6D:8B:81
pair AC:FD:93:0A:E5:AC
trust D0:27:88:6D:8B:81
trust AC:FD:93:0A:E5:AC
scan on
scan off
connect D0:27:88:6D:8B:81
connect AC:FD:93:0A:E5:AC
quit
EOF

