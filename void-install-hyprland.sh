
# install-hyprland-void.sh
# Installs Hyprland on Void Linux via the blackhole-vl third-party repo.
# No plugin/devel packages installed (hyprland-devel skipped on purpose).

set -eu

REPO_CONF="/etc/xbps.d/00-repository-main.conf"
ARCH="$(xbps-uhelper arch)"
REPO_URL="https://mirror.black-hole.dev/${ARCH}"

err() { printf 'error: %s\n' "$1" >&2; exit 1; }

[ "$(id -u)" -eq 0 ] && err "run as a normal user, not root (sudo is used internally)"
command -v xbps-install >/dev/null 2>&1 || err "xbps-install not found, is this Void Linux?"

# add blackhole-vl repo if not already configured
if ! grep -qs "mirror.black-hole.dev" "$REPO_CONF" 2>/dev/null; then
	sudo cp /usr/share/xbps.d/00-repository-main.conf "$REPO_CONF" \
		|| err "failed to seed $REPO_CONF"
	sudo sed -i "1i repository=${REPO_URL}" "$REPO_CONF" \
		|| err "failed to insert repository line"
fi

# sync repo data (also prompts fingerprint acceptance on first run)
sudo xbps-install -S || err "repository sync failed"

# core packages only, no -devel / plugin support
PKGS="hyprland xdg-desktop-portal-hyprland"

# shellcheck disable=SC2086
sudo xbps-install -y $PKGS || err "package install failed"

printf 'done: hyprland installed (no plugin support)\n'
