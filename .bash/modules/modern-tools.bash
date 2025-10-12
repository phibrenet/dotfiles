# Modern CLI tool configurations and aliases

# Configure environment variables for modern tools
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
export BAT_CONFIG_PATH="$HOME/.config/bat/config"

# Modern alternatives to classic commands
# Note: cat alias disabled due to issues with sudo cat
# Use 'bat' or 'batcat' explicitly for syntax highlighting
if command -v batcat >/dev/null 2>&1 && ! command -v bat >/dev/null 2>&1; then
    alias bat='batcat'
fi

if command -v rg >/dev/null 2>&1; then
    alias grep='rg'
    # Keep original grep available
    alias oldgrep='command grep'
fi

if command -v fd >/dev/null 2>&1; then
    alias find='fd'
    # Keep original find available
    alias oldfind='command find'
fi

if command -v exa >/dev/null 2>&1; then
    alias ls='exa --icons'
    alias la='exa --icons -la'
    alias ll='exa --icons -l'
    alias tree='exa --tree'
elif command -v lsd >/dev/null 2>&1; then
    alias ls='lsd'
    alias la='lsd -la'
    alias ll='lsd -l'
    alias tree='lsd --tree'
fi

if command -v dust >/dev/null 2>&1; then
    alias du='dust'
    alias olddu='command du'
fi

if command -v duf >/dev/null 2>&1; then
    alias df='duf'
    alias olddf='command df'
fi

if command -v procs >/dev/null 2>&1; then
    alias ps='procs'
    alias oldps='command ps'
fi

if command -v sd >/dev/null 2>&1; then
    alias sed='sd'
    alias oldsed='command sed'
fi

if command -v hyperfine >/dev/null 2>&1; then
    alias time='hyperfine'
    alias oldtime='command time'
fi

# Enhanced fzf functions
if command -v fzf >/dev/null 2>&1; then
    # Better file preview with bat
    export FZF_DEFAULT_OPTS="
        --height 80%
        --layout=reverse
        --border
        --preview 'bat --color=always --style=header,grid --line-range :300 {}'
        --preview-window=right:50%:wrap
        --bind='ctrl-/:toggle-preview'
        --bind='ctrl-u:preview-page-up'
        --bind='ctrl-d:preview-page-down'
    "
    
    # Use fd for fzf if available
    if command -v fd >/dev/null 2>&1; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
    fi
    
    # Fuzzy find and edit files
    fe() {
        local files
        IFS=$'\n' files=($(fzf --query="$1" --multi --select-1 --exit-0))
        [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
    }
    
    # Fuzzy find and cd to directory
    fcd() {
        local dir
        dir=$(fd --type d --hidden --follow --exclude .git | fzf +m) && cd "$dir"
    }
    
    # Fuzzy find in command history
    fh() {
        eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
    }
    
    # Fuzzy find and kill process
    fkill() {
        local pid
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
        if [ "x$pid" != "x" ]; then
            echo $pid | xargs kill -${1:-9}
        fi
    }
fi

# Git with modern tools
if command -v delta >/dev/null 2>&1; then
    # Git functions using delta
    gdiff() {
        git diff "$@" | delta
    }
    
    gshow() {
        git show "$@" | delta
    }
fi

# Directory navigation with modern tools
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init bash)"
    alias cd='z'
    alias cdi='zi'  # Interactive mode
fi

# Benchmark modern vs classic tools
compare-tools() {
    echo "Comparing modern vs classic CLI tools..."
    
    if command -v hyperfine >/dev/null 2>&1; then
        echo "=== find vs fd ==="
        if command -v fd >/dev/null 2>&1; then
            hyperfine 'find . -name "*.txt"' 'fd -e txt'
        fi
        
        echo "=== grep vs ripgrep ==="
        if command -v rg >/dev/null 2>&1; then
            hyperfine 'grep -r "function" .' 'rg "function"'
        fi
        
        echo "=== cat vs bat ==="
        if command -v bat >/dev/null 2>&1 && [[ -f ~/.bashrc ]]; then
            hyperfine 'cat ~/.bashrc' 'bat ~/.bashrc'
        fi
    else
        echo "Install 'hyperfine' for detailed benchmarks"
        echo "Showing basic tool availability:"
        echo "fd: $(command -v fd >/dev/null && echo "✓" || echo "✗")"
        echo "rg: $(command -v rg >/dev/null && echo "✓" || echo "✗")"
        echo "bat: $(command -v bat >/dev/null && echo "✓" || echo "✗")"
        echo "exa: $(command -v exa >/dev/null && echo "✓" || echo "✗")"
        echo "delta: $(command -v delta >/dev/null && echo "✓" || echo "✗")"
    fi
}