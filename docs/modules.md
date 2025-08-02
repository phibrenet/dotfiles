# Bash Modules

The `.bash/modules/` directory contains modular bash configurations that extend your shell with specific functionality. Each module is automatically loaded during shell initialization.

## Available Modules

### development.bash
**Purpose**: Development workflow shortcuts and project management

**Key Functions:**
- `proj [project-name]` - List projects or navigate to a specific project
- `mkproj <name>` - Create new project with git initialization and basic structure
- `serve [port]` - Start local development server (defaults to port 8000)

**Environment Variables:**
- `PROJECT_DIR` - Base directory for projects (defaults to `$HOME/projects`)

### modern-tools.bash
**Purpose**: Integration and aliases for modern CLI tools

**Provides aliases for:**
- `cat` → `bat` (syntax highlighting)
- `grep` → `rg` (ripgrep)
- `find` → `fd` (faster file finding)
- `ls` → `exa/lsd` (enhanced listing with icons)
- `du` → `dust` (disk usage)
- `df` → `duf` (disk free)
- `ps` → `procs` (process viewer)

**Environment Variables:**
- `RIPGREP_CONFIG_PATH` - Points to ripgrep configuration
- `BAT_CONFIG_PATH` - Points to bat configuration

**Note**: Original commands remain available with `old*` prefix (e.g., `oldgrep`, `oldfind`)

### performance.bash
**Purpose**: Lazy loading of heavy development tools to improve shell startup time

**Lazy-loaded tools:**
- **RVM** - Ruby Version Manager
- **NVM** - Node Version Manager  
- **virtualenvwrapper** - Python virtual environment management

**How it works:**
- Tools are only loaded when first used
- Subsequent calls use the loaded version
- Significantly reduces shell startup time

## Module Configuration

### Disabling Modules
To temporarily disable a module:
```bash
mv ~/.bash/modules/module-name.bash ~/.bash/modules/module-name.bash.disabled
```

### Adding Custom Modules
Create new `.bash` files in the modules directory. They will be automatically sourced during shell initialization.

### Module Dependencies
- `development.bash` requires git for project management
- `modern-tools.bash` automatically detects available tools
- `performance.bash` only activates if the respective tools are installed