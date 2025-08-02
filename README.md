# Dotfiles

A comprehensive collection of configuration files for a productive development environment across Linux, macOS, WSL, and Cygwin.

## Features

- **Cross-platform compatibility** - Works on Linux, macOS, WSL, and Cygwin
- **Rich shell experience** - Enhanced Bash with custom functions, aliases, and intelligent prompt
- **Modern tooling** - Integrated support for fzf, delta, ripgrep, bat, fd, exa, and more
- **Git workflow** - Extensive git aliases with safety features for efficient version control
- **Development shortcuts** - Project management, testing, and workflow automation
- **Performance optimized** - Lazy loading and modular configuration for fast startup
- **100+ custom scripts** - Extensive collection of development and system utilities
- **Modular configuration** - Organized modules for easy customization and maintenance

## Quick Install

```bash
git clone https://github.com/your-username/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## Manual Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/dotfiles.git ~/.dotfiles
   ```

2. Create symlinks to your home directory:
   ```bash
   ln -sf ~/.dotfiles/.bash_profile ~/
   ln -sf ~/.dotfiles/.bashrc ~/
   ln -sf ~/.dotfiles/.vimrc ~/
   ln -sf ~/.dotfiles/.tmux.conf ~/
   ln -sf ~/.dotfiles/.gitconfig ~/
   ln -sf ~/.dotfiles/.inputrc ~/
   ln -sf ~/.dotfiles/.sqliterc ~/
   ```

3. Create the `.bash` directory and symlink helper scripts:
   ```bash
   ln -sf ~/.dotfiles/.bash ~/
   ln -sf ~/.dotfiles/.bin ~/
   ```

4. Reload your shell:
   ```bash
   exec bash -l
   ```

## Quick Start

After installation, you'll have access to:

- **Enhanced shell** with modern CLI tool integration and smart aliases
- **Git workflow tools** with safety features and productivity shortcuts  
- **100+ custom scripts** for development, Docker, system management, and more
- **Modular configuration** that can be easily customized and extended
- **Cross-platform support** for Linux, macOS, WSL, and Cygwin

Key commands to try:
```bash
proj                    # List/navigate projects  
git-all status          # Run git commands across all repos
dclean                  # Clean up Docker environment
color-test              # Test terminal colors
is-wsl                  # Check platform
```

## Configuration Structure

```
.
├── install.sh                  # Automated installation script
├── docs/                       # Documentation
│   ├── modules.md              # Bash modules documentation  
│   └── scripts.md              # Custom scripts documentation
│
├── Shell Configuration
├── .bash_profile               # Main shell initialization
├── .bashrc                     # Interactive shell settings
├── .inputrc                    # Readline configuration
├── .bash/                      # Helper functions and utilities
│   └── modules/                # Modular bash components
│       ├── development.bash    # Development workflow shortcuts
│       ├── modern-tools.bash   # Modern CLI tool integration
│       └── performance.bash    # Lazy loading & optimization
│
├── Development Tools
├── .gitconfig                  # Git configuration with safety features
├── .vimrc                      # Vim configuration
├── .tmux.conf                  # Tmux configuration
├── .sqliterc                   # SQLite settings
├── .editorconfig               # Editor consistency settings
│
├── Modern CLI Tools
├── .ripgreprc                  # Ripgrep search configuration
├── .fdignore                   # fd file finder ignore patterns
│
├── Custom Scripts
└── .bin/                       # 100+ custom command-line tools
    ├── git-*                   # Git helper scripts (20+)
    ├── docker shortcuts        # Docker development tools
    ├── platform detection      # Cross-platform utilities
    └── development tools       # Framework and language tools
```

## Documentation

- **[Bash Modules](docs/modules.md)** - Detailed documentation for `.bash/modules/`
- **[Custom Scripts](docs/scripts.md)** - Complete reference for all `.bin/` scripts

## Customization

### Personal Settings

Create these files for personal customizations that won't be committed:

- `~/.bash_profile_personal` - Personal bash profile settings
- `~/.bashrc_personal` - Personal bashrc settings
- `~/.gitconfig_personal` - Personal git configuration
- `~/.bash_profile_local` - Local machine-specific settings
- `~/.bashrc_local` - Local machine-specific settings

### Environment Variables

Key environment variables you can set:
- `PROJECT_DIR` - Base directory for projects (defaults to `$HOME/projects`)
- `RIPGREP_CONFIG_PATH` - Ripgrep configuration file location
- `BAT_CONFIG_PATH` - bat configuration file location

## Dependencies

### Required
- Bash 4.0+
- Git 2.0+

### Recommended (auto-detected)
Modern CLI tools that enhance the experience:
- **fzf, ripgrep, bat, fd, delta, exa/lsd** - Modern CLI alternatives
- **tmux, vim** - Terminal multiplexer and editor

Install on Ubuntu/Debian:
```bash
sudo apt install ripgrep bat fd-find exa fzf
```

Install on macOS:
```bash
brew install ripgrep bat fd exa fzf delta
```

## Troubleshooting

### Performance Issues
```bash
# Check startup time and identify slow operations
benchmark-bash
profile-bash

# Disable problematic modules temporarily
mv ~/.bash/modules/MODULE.bash ~/.bash/modules/MODULE.bash.disabled
```

### Platform Detection
```bash
# Verify platform detection is working
is-wsl && echo "WSL detected"
is-mac && echo "macOS detected"
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test across different platforms
5. Submit a pull request

## License

MIT License - feel free to use and modify as needed.