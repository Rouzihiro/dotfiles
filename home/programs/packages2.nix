{pkgs, ...}: {
  home.packages = with pkgs; [
    ####################
    # User Utilities & Tools
    ####################
		python3Packages.psutil
		bleachbit
		tigervnc
    udisks2
    ntfs3g
    ventoy-full-qt
    bluez
    bitwarden-cli
    keychain
    swappy
    ffmpeg-full
    yt-dlp
    wget
    aria2
    yad
    bc
    tesseract
    translate-shell
    slurp
    xcp
    duf
    tree
    fd
    ripgrep

    gnome-font-viewer
    openjdk17
    grim
    joplin-desktop
    joplin
    miller
    jq
    unrar
    unzip
    ecmtools

    #fzf # Fuzzy finder
    #zoxide # Directory jumper
    #cliphist # Clipboard manager
    #eza # Modern replacement for `ls` with better formatting and icons

    ####################
    # File Management
    ####################
    motrix
    xfce.thunar
    vdhcoapp #Companion application for the Video DownloadHelper browser add-on.

    #gvfs # moutining Network drive
    # cifs-utils
    # uget  # ariang plowshare
    # dex
    # pdfarranger # PDF editor

    ####################
    # Media Tools
    ####################
    swww
    grimblast
    mpvpaper
    #waypipe                  # Wayland remote display tool for forwarding applications
    #ani-cli                  # CLI tool to stream or download anime
    #brightnessctl            # CLI tool to adjust screen brightness
    #cmatrix                  # "Matrix" screensaver for the terminal
    #htop                     # Interactive system monitor
    #manga-cli                # CLI manga downloader and reader
    #nhentai                  # CLI tool for accessing nhentai.net content
    #stash                    # http://localhost:9999/
    #playerctl                # CLI media player controller
    #zathura                  # Lightweight PDF viewer
    #imagemagick              # Image manipulation tool
    #imv                      # Lightweight image viewer
    #pinta                    # Image editor
    #vlc                      # Media player

    ####################
    # Communication
    ####################
    nchat
    teams-for-linux
    thunderbird # Email client

    # vesktop                  # Discord client
    # discordo                 # Discord cli
    # telegram-desktop         # Messaging app
    # zoom-us                  # Video conferencing
    # skypeforlinux            # Skype client
    # whatsapp-for-linux
    # element-desktop          # Decentralized messaging app
    # anydesk                  # Remote desktop client
    # localsend                # Local file sharing

    ####################
    # Programming & Development
    ####################
    nodejs
    alejandra

    #gcc                      # GNU Compiler Collection for C, C++, and other languages
    #live-server              # Development server with live reloading
    #nixfmt-rfc-style         # Formatter for Nix files adhering to RFC standards

    ####################
    # Wayland Specific
    ####################
    wob
    wl-clipboard # Clipboard manager

    # rofi-wayland
    # dunst                    # Notification daemon

    ####################
    # Miscellaneous
    ####################
    # cmatrix                  # Matrix effect in terminal
    # lolcat                   # Colorize terminal output
    # onefetch                 # Git repository overview
    # cowsay                   # Fun ASCII art generator

    ####################
    # Education
    ####################
    libreoffice
    # calligra
    # onlyoffice-desktopeditors # only X11
    # ciscoPacketTracer8       # Networking simulator
    # wireshark                # Network analysis tool

    ####################
    # Music and Streaming
    ####################
    # youtube-music            # YouTube Music client
    # spotify                  # Music streaming client

    ####################
    # Network and Internet Tools
    ####################
    # qbittorrent              # Torrent client
    # cloudflare-warp          # VPN
    # tailscale                # Mesh VPN
    # onedrive                 # Cloud storage

    ####################
    # Browsers
    ####################
    # vivaldi                  # Chromium-based browser
    # falkon                   # Lightweight Qt-based web browser (didnt handle open-AI)
  ];
}
