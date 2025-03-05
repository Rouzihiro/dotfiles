{pkgs}:
pkgs.writeShellScriptBin "teams-x11" ''
  #!/bin/sh
  # Launch teams-for-linux with X11 backend
  ELECTRON_OZONE_PLATFORM_HINT=x11 teams-for-linux
''
