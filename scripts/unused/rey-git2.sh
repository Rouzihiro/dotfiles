#!/bin/mksh

# insert push to push
# insert pull to pull

# Configuration
SSH_KEY="$HOME/.ssh/id_rsa"
GITHUB_USERNAME="Rouzihiro"  # Your GitHub username
REMOTE_REPO="git@github.com:$GITHUB_USERNAME/$(basename "$PWD").git"  # Remote repository URL

# Function to check if SSH key is already added
is_ssh_key_added() {
  ssh-add -l | grep -q "$(ssh-keygen -lf $SSH_KEY | awk '{print $2}')"
}

# Start the SSH agent if not already running
if [ -z "$SSH_AGENT_PID" ]; then
  eval "$(ssh-agent -s)"
fi

# Add SSH key to the agent if not already added
if ! is_ssh_key_added; then
  ssh-add "$SSH_KEY"
fi

# Initialize and push repository
push_repo() {
  git init

  # Add all files in the current directory (including subfolders)
  git add .

  git commit -m "Initial commit"

  # Remove existing remote if any
  git remote remove origin 2>/dev/null

  # Add the correct remote
  git remote add origin "$REMOTE_REPO"

  # Check the current branch
  current_branch=$(git branch --show-current)
  if [ "$current_branch" = "master" ]; then
    git branch -m master main
  fi

  git push -u origin main
}

# Pull the latest changes from the remote repository
pull_repo() {
  # Check if the repository has already been initialized
  if [ -d ".git" ]; then
    git pull origin main
  else
    echo "Repository is not initialized. Run the script to push the repository first."
  fi
}

# Command-line argument to decide whether to push or pull
if [ "$1" = "push" ]; then
  push_repo
elif [ "$1" = "pull" ]; then
  pull_repo
else
  echo "Usage: $0 {push|pull}"
fi