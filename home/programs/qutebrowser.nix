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
      rapid-movies = "https://rmz.cr";
      noodle = "https://noodlemagazine.com";
      firgirl = "https://fitgirl-repacks.site";
      dodi = "https://dodi-repacks.site";
      mma1 = "https://realfight.org/category/mma-boxing";
      ovd = "https://www.savethevideo.com";
      Anime-watch = "https://hianime.to";
      Anime-dl = "https://wotaku.wiki/websites#download";
      Anime-links = "https://fmhy.net/videopiracyguide#anime-downloading";
      Anime-check = "https://github.com/fmhy/FMHY/wiki/Stream-Site-Grading";
      movies-fz = "https://fzmovies.net/movieslist.php?catID=2&by=latest";
      games-igg = "https://igg-games.com";
      games-x = "https://lewdgames.to/all-games";
      markdown-online = "https://dillinger.io";
      overleaf = "https://www.overleaf.com";
      maps = "https://www.google.de/maps";

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
