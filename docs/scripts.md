# Custom Scripts (.bin)

The `.bin` directory contains custom command-line tools and utilities. These scripts are automatically added to your PATH when the dotfiles are installed.

## Git Utilities

### Core Git Commands
- `git-all` - Run git commands across all subdirectories with repositories
- `git-cls <class>` - Search for class definitions in code (`git grep` wrapper)
- `git-pu [url]` - Push current branch and set upstream (optionally set origin URL)
- `git-safe` - Display available git safety commands
- `git-squash` - Interactive commit squashing
- `git-main` - Switch to main/master branch automatically

### Repository Management
- `git-bclean` - Clean up merged branches
- `git-gc-all` - Run garbage collection on all repos
- `git-set-origin` - Set repository origin URL
- `git-fix-push-url` - Fix push URL configuration

### Branch and Workflow
- `git-in` - Show incoming commits (fetch + log)
- `git-out` - Show outgoing commits 
- `git-mi` - Merge with information
- `git-pt` - Push with tags

## Development Tools

### Project Utilities
- `cfg` - Quick configuration file editor
- `dev` - Development environment setup
- `extract` - Universal archive extraction tool
- `findup <pattern>` - Find files recursively upward in directory tree

### Docker Shortcuts
- `dclean` - Clean up Docker containers and images
- `dkill` - Kill Docker containers
- `dkillall` - Kill all Docker containers
- `dserve` - Start development server in Docker
- `dsh` - Shell into Docker container
- `dstop` / `dstopall` - Stop Docker containers

### Framework Tools
- `artisan` - Laravel Artisan wrapper
- `drush` - Drupal Drush wrapper
- `wp` - WordPress CLI wrapper
- `serverless` / `sls` - Serverless framework
- `jest` - Jest testing framework
- `cypress` - Cypress testing tool

## System Utilities

### Platform Detection
- `is-cygwin` - Check if running on Cygwin
- `is-docker` - Check if running in Docker
- `is-mac` - Check if running on macOS
- `is-ubuntu` - Check if running on Ubuntu
- `is-wsl` - Check if running on WSL

### Network and System
- `myip` - Show external IP address
- `pping` - Pretty ping with colors
- `ntp` - Network time sync
- `termbin` - Upload text to termbin.com
- `pwgen` - Generate secure passwords

### File Operations
- `count-files` - Count files by type
- `dus` - Disk usage summary with colors
- `tarc` - Create compressed archives
- `umv` - Bulk file renaming utility
- `sed-all` - Run sed across multiple files

## Utility Functions

### Text Processing
- `color-test` - Test terminal color support
- `gethexcode` - Get color hex codes
- `natsort` - Natural sorting of input
- `timestamp-to-date` - Convert timestamps to readable dates
- `unserialize` - PHP unserialize utility

### System Management
- `fix-ssh-agent` - Repair SSH agent forwarding
- `fix-ssh-permissions` - Fix SSH key permissions
- `setup-ubuntu` - Ubuntu environment setup
- `setup-aws-cloudshell` - AWS CloudShell configuration

### Smart Wrappers
- `delta-or-less` - Use delta if available, fallback to less
- `bat-or-cat` - Use bat if available, fallback to cat
- `grep-less` - Grep with paging
- `maybe-sudo` - Run command with sudo only if needed

## Windows Integration (WSL)

### Windows Tools
- `explorer` - Open Windows Explorer from WSL
- `phpstorm` - Launch PhpStorm from WSL
- `kubectl` - Kubernetes CLI via Windows
- `minikube` - Minikube via Windows

### Path Utilities
- `wsl-localappdata-path` - Get Windows LocalAppData path
- `wsl-mydocs-path` - Get Windows Documents path  
- `wsl-temp-path` - Get Windows temp directory path

## Usage Examples

```bash
# Run git status on all projects
git-all status

# Search for a class definition
git cls UserController

# Push current branch and set upstream
git pu

# Clean up Docker environment
dclean

# Check what platform you're on
is-wsl && echo "Running on WSL"

# Generate a secure password
pwgen 16

# Show external IP
myip

# Extract any archive type
extract archive.tar.gz
extract archive.zip
extract archive.rar
```

## Adding Custom Scripts

1. Create executable script in `.bin/` directory
2. Make it executable: `chmod +x ~/.bin/script-name`
3. Reload shell or run: `source ~/.bashrc`

Scripts are automatically added to PATH and available system-wide.