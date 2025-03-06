{pkgs, ...}: {
  home.packages = with pkgs; [
    ####################
    # User Utilities & Tools
    ####################
    bitwarden-cli
    keychain
    wget
    yad
    gnome-font-viewer
    openjdk17
    openssl
    bc
    tesseract
    grim
    slurp
    translate-shell # needed for Screenshot - OCR script
    joplin-desktop
    joplin
    xcp
    duf
    tree
    fd
    ripgrep # Fast command-line search tool for finding text in files
    miller
    jq
    unrar
    unzip #p7zip
    ecmtools

    #fzf # Fuzzy finder
    #jq # JSON parser
    #zoxide # Directory jumper
    #cliphist # Clipboard manager
    #eza # Modern replacement for `ls` with better formatting and icons

    ####################
    # File Management
    ####################
    motrix
    xfce.thunar
    aria2 # Download manager
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
    mpvpaper
    ffmpeg-full # Multimedia utilities
    yt-dlp # Download videos from YouTube and other platforms

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
    #mpv

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
    libreoffice

    # cmatrix                  # Matrix effect in terminal
    # lolcat                   # Colorize terminal output
    # onefetch                 # Git repository overview
    # cowsay                   # Fun ASCII art generator

    ####################
    # Education
    ####################
    # calligra
    # onlyoffice-desktopeditors # only X11
    # ciscoPacketTracer8       # Networking simulator
    # wireshark                # Network analysis tool
    # ventoy                   # Bootable USB creator

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
