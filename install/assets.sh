#!/bin/bash

# Script to setup and update assets repository with enhanced error handling

set -euo pipefail

readonly PROJECTS_DIR="$HOME/projects"
readonly ASSETS_DIR="$PROJECTS_DIR/assets"
readonly ASSETS_REPO="https://github.com/Rouzihiro/assets.git"

log_info() {
    echo "[INFO] $(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log_error() {
    echo "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') - $1" >&2
}

check_git_installed() {
    if ! command -v git &> /dev/null; then
        log_error "git is not installed. Please install git first."
        exit 1
    fi
}

setup_projects_dir() {
    log_info "Creating Projects directory..."
    if ! mkdir -p "$PROJECTS_DIR"; then
        log_error "Failed to create directory: $PROJECTS_DIR"
        exit 1
    fi
}

handle_existing_repo() {
    log_info "Assets repository exists. Checking for updates..."
    
    cd "$ASSETS_DIR" || {
        log_error "Cannot access directory: $ASSETS_DIR"
        exit 1
    }
    
    # Get current branch
    local current_branch
    current_branch=$(git symbolic-ref --short HEAD 2>/dev/null || echo "unknown")
    
    log_info "Current branch: $current_branch"
    
    # Check if we have uncommitted changes
    if ! git diff-index --quiet HEAD -- 2>/dev/null; then
        log_info "Repository has uncommitted changes. Stashing them..."
        git stash push -m "Auto-stash by setup script $(date '+%Y-%m-%d_%H:%M:%S')"
    fi
    
    # Try to pull
    if git pull origin "$current_branch" 2>/dev/null; then
        log_info "Repository updated successfully."
    else
        log_info "Trying to pull main/master branch..."
        if git pull origin main 2>/dev/null || git pull origin master 2>/dev/null; then
            log_info "Repository updated successfully."
        else
            log_error "Failed to pull updates. Please check your repository status."
            git status
            exit 1
        fi
    fi
}

clone_repo() {
    log_info "Cloning assets repository..."
    
    if [ -d "$ASSETS_DIR" ]; then
        log_info "Directory exists but is not a git repository. Creating backup..."
        local backup_dir="$ASSETS_DIR.backup.$(date +%Y%m%d_%H%M%S)"
        if ! mv "$ASSETS_DIR" "$backup_dir"; then
            log_error "Failed to backup existing directory."
            exit 1
        fi
        log_info "Backup created at: $backup_dir"
    fi
    
    cd "$PROJECTS_DIR" || exit 1
    
    if ! git clone "$ASSETS_REPO"; then
        log_error "Failed to clone repository. Check your internet connection and repository URL."
        exit 1
    fi
    
    log_info "Repository cloned successfully."
}

run_symlink_script() {
    local symlink_script="$ASSETS_DIR/symlink.sh"
    
    if [ ! -f "$symlink_script" ]; then
        log_error "symlink.sh not found at: $symlink_script"
        log_info "Contents of assets directory:"
        ls -la "$ASSETS_DIR/" 2>/dev/null || echo "Directory is empty"
        exit 1
    fi
    
    log_info "Found symlink.sh. Running it..."
    
    # Check if executable
    if [ ! -x "$symlink_script" ]; then
        log_info "Making symlink.sh executable..."
        chmod +x "$symlink_script"
    fi
    
    # Run in the correct directory
    cd "$ASSETS_DIR" || exit 1
    
    if bash "$symlink_script"; then
        log_info "symlink.sh executed successfully."
    else
        log_error "symlink.sh failed with exit code $?"
        exit 1
    fi
}

main() {
    log_info "Starting assets setup..."
    
    check_git_installed
    setup_projects_dir
    
    if [ -d "$ASSETS_DIR/.git" ]; then
        handle_existing_repo
    else
        clone_repo
    fi
    
    run_symlink_script
    
    log_info "Setup completed successfully!"
}

# Run main function
main "$@"
