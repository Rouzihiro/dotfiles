{pkgs, ...}: {
  home.packages = with pkgs; [
    hyprpolkitagent
    bitwarden-cli
    alejandra
    xfce.thunar
    jq
    swww
    keychain
    teams-for-linux
    wob
    #glow
    miller
    libreoffice
    ecmtools
    unrar
    unzip #p7zip
    #gvfs # moutining Network drive
    # cifs-utils
    vdhcoapp #Companion application for the Video DownloadHelper browser add-on.
    mpvpaper
    yad
    gnome-font-viewer
    wget
    # uget  # ariang plowshare
    # dex
    # pdfarranger # PDF editor

    # User Utilities & Tools
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

    #fzf # Fuzzy finder
    #jq # JSON parser
    #zoxide # Directory jumper
    #cliphist # Clipboard manager
    #eza # Modern replacement for `ls` with better formatting and icons

    ####################
    # Programming & Development
    ####################
    nodejs
    #gcc                      # GNU Compiler Collection for C, C++, and other languages
    #live-server              # Development server with live reloading
    #nixfmt-rfc-style         # Formatter for Nix files adhering to RFC standards
    ripgrep                   # Fast command-line search tool for finding text in files

    ####################
    # Media Tools
    ####################
    #yt-dlp                   # Download videos from YouTube and other platforms
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
    ffmpeg-full               # Multimedia utilities
    #imagemagick              # Image manipulation tool
    #imv                      # Lightweight image viewer
    #pinta                    # Image editor
    #vlc                      # Media player
    #mpv

    # Browsers
    # vivaldi                  # Chromium-based browser
    # falkon                   # Lightweight Qt-based web browser (didnt handle open-AI)

    # Communication
    # vesktop                  # Discord client
    # discordo                 # Discord cli
    # telegram-desktop         # Messaging app
    thunderbird # Email client
    # zoom-us                  # Video conferencing
    # skypeforlinux            # Skype client
    # whatsapp-for-linux
    # element-desktop          # Decentralized messaging app
    # anydesk                  # Remote desktop client
    # localsend                # Local file sharing

    # Network and Internet Tools
    aria2                      # Download manager
    # qbittorrent              # Torrent client
    # cloudflare-warp          # VPN
    # tailscale                # Mesh VPN
    # onedrive                 # Cloud storage

    # Wayland Specific
    # rofi-wayland
    # dunst                    # Notification daemon
    wl-clipboard # Clipboard manager

    # Miscellaneous
    # cmatrix                  # Matrix effect in terminal
    # lolcat                   # Colorize terminal output
    # onefetch                 # Git repository overview
    # cowsay                   # Fun ASCII art generator

    # Education
    # calligra
    # onlyoffice-desktopeditors # only X11
    # ciscoPacketTracer8       # Networking simulator
    # wireshark                # Network analysis tool
    # ventoy                   # Bootable USB creator

    # Music and Streaming
    # youtube-music            # YouTube Music client
    # spotify                  # Music streaming client
  ];
}
