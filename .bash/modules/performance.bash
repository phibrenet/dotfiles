# Performance optimizations for bash startup
# Source this file to enable lazy loading of heavy tools

# Lazy load RVM
if [[ -s ~/.rvm/scripts/rvm ]]; then
    rvm() {
        if [[ -z ${RVM_LOADED:-} ]]; then
            echo "Loading RVM..."
            rvm_project_rvmrc=0
            source ~/.rvm/scripts/rvm
            export RVM_LOADED=1
        fi
        command rvm "$@"
    }
fi

# Lazy load virtualenv wrapper
if [[ -f /usr/local/bin/virtualenvwrapper_lazy.sh ]]; then
    workon() {
        if [[ -z ${VIRTUALENV_LOADED:-} ]]; then
            echo "Loading virtualenvwrapper..."
            export VIRTUAL_ENV_DISABLE_PROMPT=1
            source /usr/local/bin/virtualenvwrapper_lazy.sh
            export VIRTUALENV_LOADED=1
        fi
        command workon "$@"
    }
    
    mkvirtualenv() {
        if [[ -z ${VIRTUALENV_LOADED:-} ]]; then
            echo "Loading virtualenvwrapper..."
            export VIRTUAL_ENV_DISABLE_PROMPT=1
            source /usr/local/bin/virtualenvwrapper_lazy.sh
            export VIRTUALENV_LOADED=1
        fi
        command mkvirtualenv "$@"
    }
fi

# Lazy load nvm
if [[ -s ~/.nvm/nvm.sh ]]; then
    nvm() {
        if [[ -z ${NVM_LOADED:-} ]]; then
            echo "Loading NVM..."
            source ~/.nvm/nvm.sh
            export NVM_LOADED=1
        fi
        command nvm "$@"
    }
    
    node() {
        if [[ -z ${NVM_LOADED:-} ]] && ! command -v node >/dev/null 2>&1; then
            echo "Loading NVM for Node.js..."
            source ~/.nvm/nvm.sh
            export NVM_LOADED=1
        fi
        command node "$@"
    }
    
    npm() {
        if [[ -z ${NVM_LOADED:-} ]] && ! command -v npm >/dev/null 2>&1; then
            echo "Loading NVM for npm..."
            source ~/.nvm/nvm.sh
            export NVM_LOADED=1
        fi
        command npm "$@"
    }
fi

# Benchmark bash startup time
benchmark-bash() {
    local count=${1:-5}
    echo "Benchmarking bash startup time ($count runs)..."
    
    for ((i=1; i<=count; i++)); do
        /usr/bin/time -p bash -lic 'exit' 2>&1 | grep real | awk '{print $2}'
    done | awk '{sum += $1; count++} END {print "Average startup time: " sum/count " seconds"}'
}

# Profile bash startup
profile-bash() {
    PS4='+ $(date "+%s.%N")\011 '
    exec 3>&2 2>/tmp/bashstart.$$.log
    set -x
    source ~/.bashrc
    set +x
    exec 2>&3 3>&-
    
    echo "Bash startup profile saved to /tmp/bashstart.$$.log"
    echo "Analyzing slowest operations..."
    
    awk '
    BEGIN { FS="\t" }
    /^\+/ {
        if (prev) {
            duration = $1 - prev
            if (duration > 0.01) {  # Show operations taking more than 10ms
                print duration "s: " prev_line
            }
        }
        prev = $1
        prev_line = $2
    }
    ' /tmp/bashstart.$$.log | sort -nr | head -10
}