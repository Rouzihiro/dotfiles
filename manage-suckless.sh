#!/bin/bash
# Fully automated suckless submodule manager for dotfiles

# repos: remote → local path inside dotfiles
declare -A repos=(
  ["git@github.com:Rouzihiro/suckless-st.git"]=".config/suckless/st"
  ["git@github.com:Rouzihiro/dmenu.git"]=".config/suckless/dmenu"
  # ["git@github.com:Rouzihiro/dwm.git"]=".config/suckless/dwm" # optional, uncomment if you want dwm as submodule
)

# branch to track
BRANCH="main"

# ensure we are inside the dotfiles repo
if [ ! -d ".git" ]; then
  echo "❌ Run this script from the root of your dotfiles repo."
  exit 1
fi

# loop through repos
for remote in "${!repos[@]}"; do
  local_path="${repos[$remote]}"

  if [ -d "$local_path/.git" ]; then
    echo "🔄 Updating existing submodule: $local_path"
  else
    echo "➕ Adding new submodule: $local_path"
    git submodule add "$remote" "$local_path"
  fi

  # configure branch tracking
  git config -f .gitmodules submodule."$local_path".branch "$BRANCH"
done

# fetch and update all submodules to latest upstream
echo "📥 Fetching and merging latest upstream for all submodules..."
git submodule update --remote --merge

# commit any submodule pointer changes
git add .gitmodules .config/suckless
git commit -m "Update suckless submodules to latest upstream" 2>/dev/null || echo "Nothing to commit"

# push changes
git push
