# Setup theme links
mkdir -p ~/.config/zorro/themes
for f in ~/dotfiles/themes/*; do ln -nfs "$f" ~/.config/zorro/themes/; done

# Set initial theme
mkdir -p ~/.config/zorro/current
ln -snf ~/.config/zorro/themes/gruvbox ~/.config/zorro/current/theme
ln -snf "$(find ~/.config/zorro/current/theme/backgrounds -type f -o -type l | shuf -n1)" ~/.config/zorro/current/background

# Set specific app links for current theme
ln -snf ~/.config/zorro/current/theme/nvim.lua ~/.config/nvim/lua/theme.lua

mkdir -p ~/.themes

mkdir -p ~/.config/btop/themes
ln -snf ~/.config/zorro/current/theme/btop.theme ~/.config/btop/themes/current.theme

mkdir -p ~/.config/broot/skins
ln -snf ~/.config/zorro/current/theme/broot.toml ~/.config/broot/skins/current.toml 

mkdir -p ~/.config/foot
ln -snf ~/.config/zorro/current/theme/foot.ini ~/.config/foot/current-theme.ini

mkdir -p ~/.config/kitty
ln -snf ~/.config/zorro/current/theme/kitty.conf ~/.config/kitty/colors.conf

mkdir -p ~/.config/rofi
ln -snf ~/.config/zorro/current/theme/rofi.rasi ~/.config/rofi/colors.rasi

mkdir -p ~/.config/zsh
ln -snf ~/.config/zorro/current/theme/dircolors ~/.config/zsh/.dircolors

mkdir -p ~/.config/tmux

mkdir -p ~/.config/yazi
ln -snf ~/.config/zorro/current/theme/yazi.toml ~/.config/yazi/theme.toml

mkdir -p ~/.config/walker
ln -nsf ~/.config/zorro/current/theme/walker.css ~/.config/walker/walker.css

mkdir -p ~/.config/wofi
ln -nsf ~/.config/zorro/current/theme/walker.css ~/.config/wofi/walker.css

mkdir -p ~/.config/lazygit
ln -snf ~/.config/zorro/current/theme/lazygit.yml ~/.config/lazygit/config.yml

mkdir -p ~/.config/sway/config.d/
ln -snf ~/.config/zorro/current/theme/sway-theme ~/.config/sway/config.d/theme

mkdir -p ~/.config/eza
ln -nsf ~/.config/zorro/current/theme/eza.yml ~/.config/eza/theme.yml

# ln -snf $HOME/dotfiles/.config/starship.toml $HOME/.config/starship.toml

mkdir -p ~/.config/i3blocks
ln -sf ~/.config/zorro/current/theme/i3blocks.config ~/.config/i3blocks/config
ln -sf ~/.config/zorro/current/theme/bar ~/.config/sway/config.d/bar

mkdir -p ~/.config/mako
ln -snf ~/.config/zorro/current/theme/mako.ini ~/.config/mako/config

z-theme-cache
