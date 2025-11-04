# Set gnome theme settings
# gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
# gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
# gsettings set org.gnome.desktop.interface icon-theme "Yaru-blue"

# Set links for Nautilius action icons
# sudo ln -snf /usr/share/icons/Adwaita/symbolic/actions/go-previous-symbolic.svg /usr/share/icons/Yaru/scalable/actions/go-previous-symbolic.svg
# sudo ln -snf /usr/share/icons/Adwaita/symbolic/actions/go-next-symbolic.svg /usr/share/icons/Yaru/scalable/actions/go-next-symbolic.svg
# sudo gtk-update-icon-cache /usr/share/icons/Yaru

# Setup theme links
mkdir -p ~/.config/zorro/themes
for f in ~/dotfiles/themes/*; do ln -nfs "$f" ~/.config/zorro/themes/; done

# Set initial theme
mkdir -p ~/.config/zorro/current
ln -snf ~/.config/zorro/themes/rose-pine-darker ~/.config/zorro/current/theme
ln -snf ~/.config/zorro/current/theme/backgrounds/01_background.png ~/.config/zorro/current/background

# Set specific app links for current theme
# ln -snf ~/.config/zorro/current/theme/neovim.lua ~/.config/nvim/lua/plugins/theme.lua

mkdir -p ~/.config/btop/themes
ln -snf ~/.config/zorro/current/theme/btop.theme ~/.config/btop/themes/current.theme

mkdir -p ~/.config/foot
ln -snf ~/.config/zorro/current/theme/foot.ini ~/.config/foot/current-theme.ini

mkdir -p ~/.config/lazygit
ln -snf ~/.config/zorro/current/theme/lazygit.yml ~/.config/lazygit/config.yml

mkdir -p ~/.config/mako
ln -snf ~/.config/zorro/current/theme/mako.ini ~/.config/mako/config
