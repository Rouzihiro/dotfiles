{ pkgs }:

pkgs.writeShellScriptBin "browse-web" ''
    declare -A URLS

    URLS=(
  ["🌎 Search"]="https://search.brave.com/search?q="
  ["🌐 Google"]="https://www.google.com/search?q="
  ["🎞️ YouTube"]="https://www.youtube.com/results?search_query="
  ["🌌 Reddit"]="https://www.reddit.com/search/?q="
  ["📙 GitHub"]="https://github.com/search?q="
  ["🦊 Firefox Add-ons"]="https://addons.mozilla.org/en-US/firefox/search/?q="
  ["📦 Nix Stable Packages"]="https://search.nixos.org/packages?channel=stable&from=0&size=50&sort=relevance&type=packages&query="
  ["❄️  Nixvim"]="https://nix-community.github.io/nixvim/search/?query="
  ["❄️  Unstable Packages"]="https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query="
  ["🔧 Nix Options"]="https://search.nixos.org/options?channel=unstable&query="
  ["📜 Nixpkgs Manual"]="https://nixos.org/manual/nixpkgs/stable/#sec-search-packages"
  ["📘 NixOS Manual"]="https://nixos.org/manual/nixos/stable/#search="
  ["📕 Nix CLI Manual"]="https://nixos.org/manual/nix/stable/#search="
  ["🛠️ Flake Registry"]="https://github.com/NixOS/flake-registry/blob/master/flake-registry.json#L"
  ["📂 Nixpkgs GitHub"]="https://github.com/NixOS/nixpkgs/search?q="
  ["🐧 Kernel Docs"]="https://www.kernel.org/doc/html/latest/search.html?q="
  ["📚 MDN Web Docs"]="https://developer.mozilla.org/en-US/search?q="
  ["📘 Stack Overflow"]="https://stackoverflow.com/search?q="
  ["🎨 Unsplash"]="https://unsplash.com/s/photos/"
  ["📜 Wikipedia"]="https://en.wikipedia.org/wiki/Special:Search?search="
  ["📚 Python Docs"]="https://docs.python.org/3/search.html?q="
  ["⚙️  Man Pages"]="https://man7.org/linux/man-pages/man1/"
  ["🐋 Docker Hub"]="https://hub.docker.com/search?q="
  ["🐍 PyPI"]="https://pypi.org/search/?q="
  ["📰 Hacker News"]="https://hn.algolia.com/?q="
  ["🎩 Nix Pills"]="https://nixos.org/guides/nix-pills/"
  ["🌐 Discourse (Forums)"]="https://discourse.nixos.org/search?q="
  ["💬 IRC Logs"]="https://logs.nix.samueldr.com/search?query="

    )

    gen_list() {
      for i in "''${!URLS[@]}"
      do
        echo "$i"
      done
    }

    main() {
      platform=$( (gen_list) | ${pkgs.wofi}/bin/wofi --dmenu )

      if [[ -n "$platform" ]]; then
        query=$( (echo ) | ${pkgs.wofi}/bin/wofi --dmenu )

        if [[ -n "$query" ]]; then
  	url=''${URLS[$platform]}$query
  	xdg-open "$url"
        else
  	exit
        fi
      else
        exit
      fi
    }

    main

    exit 0
''

