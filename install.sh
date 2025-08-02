#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Create backup of existing file
backup_file() {
    local file="$1"
    if [[ -f "$file" && ! -L "$file" ]]; then
        log_warning "Backing up existing $file to ${file}.backup"
        mv "$file" "${file}.backup"
    elif [[ -L "$file" ]]; then
        log_info "Removing existing symlink $file"
        rm "$file"
    fi
}

# Create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    
    if [[ ! -f "$source" && ! -d "$source" ]]; then
        log_error "Source file/directory $source does not exist"
        return 1
    fi
    
    backup_file "$target"
    
    log_info "Creating symlink: $target -> $source"
    ln -sf "$source" "$target"
}

# Main installation function
main() {
    local dotfiles_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    
    log_info "Installing dotfiles from $dotfiles_dir"
    
    # Ensure we're in the right directory
    cd "$dotfiles_dir"
    
    # Create necessary directories
    log_info "Creating necessary directories..."
    mkdir -p ~/.cache/vim
    mkdir -p ~/.ssh
    mkdir -p ~/.config/bash
    mkdir -p ~/.local
    
    # Core shell configuration
    log_info "Installing shell configuration..."
    create_symlink "$dotfiles_dir/.bash_profile" "$HOME/.bash_profile"
    create_symlink "$dotfiles_dir/.bashrc" "$HOME/.bashrc"
    create_symlink "$dotfiles_dir/.inputrc" "$HOME/.inputrc"
    
    # Git configuration
    log_info "Installing git configuration..."
    create_symlink "$dotfiles_dir/.gitconfig" "$HOME/.gitconfig"
    
    # Vim configuration
    if command_exists vim; then
        log_info "Installing vim configuration..."
        create_symlink "$dotfiles_dir/.vimrc" "$HOME/.vimrc"
        create_symlink "$dotfiles_dir/.vim" "$HOME/.vim"
    else
        log_warning "Vim not found, skipping vim configuration"
    fi
    
    # Tmux configuration
    if command_exists tmux; then
        log_info "Installing tmux configuration..."
        create_symlink "$dotfiles_dir/.tmux.conf" "$HOME/.tmux.conf"
    else
        log_warning "Tmux not found, skipping tmux configuration"
    fi
    
    # SQL configuration
    log_info "Installing SQL configuration..."
    create_symlink "$dotfiles_dir/.sqliterc" "$HOME/.sqliterc"
    
    # Bin directory
    log_info "Installing custom scripts..."
    create_symlink "$dotfiles_dir/.bin" "$HOME/.bin"
    
    # Bash helper directory
    log_info "Installing bash helpers..."
    create_symlink "$dotfiles_dir/.bash" "$HOME/.bash"
    
    # Azure configuration
    if [[ -d "$dotfiles_dir/.azure" ]]; then
        log_info "Installing Azure CLI configuration..."
        create_symlink "$dotfiles_dir/.azure" "$HOME/.azure"
    fi
    
    # Optional configurations
    if [[ -f "$dotfiles_dir/.minttyrc" ]]; then
        log_info "Installing MinTTY configuration..."
        create_symlink "$dotfiles_dir/.minttyrc" "$HOME/.minttyrc"
    fi
    
    # Create personal configuration files if they don't exist
    log_info "Creating personal configuration templates..."
    
    if [[ ! -f "$HOME/.bash_profile_personal" ]]; then
        cat > "$HOME/.bash_profile_personal" << 'EOF'
#
# Personal bash profile settings
# This file is sourced by .bash_profile and is not committed to git
#

# Example: Add personal PATH entries
# export PATH="$HOME/my-tools:$PATH"

# Example: Set personal environment variables
# export MY_PERSONAL_VAR="value"
EOF
        log_success "Created $HOME/.bash_profile_personal template"
    fi
    
    if [[ ! -f "$HOME/.bashrc_personal" ]]; then
        cat > "$HOME/.bashrc_personal" << 'EOF'
#
# Personal bashrc settings
# This file is sourced by .bashrc and is not committed to git
#

# Example: Personal aliases
# alias myserver="ssh user@myserver.com"

# Example: Personal functions
# myfunc() {
#     echo "My personal function"
# }
EOF
        log_success "Created $HOME/.bashrc_personal template"
    fi
    
    if [[ ! -f "$HOME/.gitconfig_personal" ]]; then
        cat > "$HOME/.gitconfig_personal" << 'EOF'
[user]
    # Override the default user settings
    # name = Your Name
    # email = your.email@example.com

# [github]
#     user = your-github-username

# [core]
#     # Personal editor preference
#     # editor = code --wait
EOF
        log_success "Created $HOME/.gitconfig_personal template"
    fi
    
    # Install optional modern tools
    log_info "Checking for modern CLI tools..."
    
    # Check for fzf
    if ! command_exists fzf; then
        log_warning "fzf not found. Install with: git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install"
    else
        log_success "fzf found"
    fi
    
    # Check for ripgrep
    if ! command_exists rg; then
        log_warning "ripgrep not found. Install with your package manager (apt install ripgrep, brew install ripgrep, etc.)"
    else
        log_success "ripgrep found"
    fi
    
    # Check for bat
    if ! command_exists bat && ! command_exists batcat; then
        log_warning "bat not found. Install with your package manager (apt install bat, brew install bat, etc.)"
    else
        log_success "bat found"
    fi
    
    # Check for delta
    if ! command_exists delta; then
        log_warning "delta not found. Install from: https://github.com/dandavison/delta"
    else
        log_success "delta found"
    fi
    
    log_success "Dotfiles installation completed!"
    log_info "Please restart your shell or run: exec bash -l"
    
    # Offer to reload the shell
    echo
    read -p "Reload shell now? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        exec bash -l
    fi
}

# Check if script is being run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi