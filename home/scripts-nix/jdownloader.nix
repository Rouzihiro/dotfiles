{pkgs}:
pkgs.writeShellScriptBin "jdownloader" ''
  #!/bin/sh
  java -jar ~/apps/JDownloader/JDownloader.jar & disown
''
