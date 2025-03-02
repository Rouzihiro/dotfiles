{pkgs, ...}: {
  home.packages = with pkgs; [qutebrowser];

  programs.qutebrowser = {
    enable = true;

    quickmarks = {
      calendar = "https://calendar.google.com";
      chatgpt = "https://chat.openai.com";
      deep-seek = "https://chat.deepseek.com";
      drive = "https://drive.google.com/drive/my-drive";
      discord = "https://www.discord.com";
      github = "https://github.com/dashboard";
      gmail = "https://mail.google.com/mail";
      google = "https://www.google.com";
      hacker_news = "https://news.ycombinator.com";
      home-manager = "https://nix-community.github.io/home-manager/options.xhtml";
      nixpkgs = "https://search.nixos.org/packages";
      boberg = "https://portal.bgk-hamburg.de/cgi-bin/login";
      reddit = "https://www.reddit.com";
      sheet = "https://raw.githubusercontent.com/qutebrowser/qutebrowser/main/doc/img/cheatsheet-big.png";
      translate = "https://translate.google.com";
      twitch = "https://www.twitch.tv";
      youtube = "https://www.youtube.com";
    };

    extraConfig = ''
      c.url.searchengines = {
        "DEFAULT": "https://duckduckgo.com/?ia=web&q={}",
        "!g": "https://google.com/search?hl=en&q={}",
        "!d": "https://duckduckgo.com/?ia=web&q={}",
        "!b": "https://search.brave.com/search?q={}&source=web",
      }
    '';

    settings = {
      url = {
        default_page = "https://start.duckduckgo.com";
        start_pages = ["https://start.duckduckgo.com"];
      };

      tabs = {
        show = "multiple";
      };

      downloads = {
        position = "bottom";
      };

      content = {
        javascript = {
          clipboard = "access";
        };
      };
      colors = {
        webpage.preferred_color_scheme = "dark";
      };
    };
  };
}
