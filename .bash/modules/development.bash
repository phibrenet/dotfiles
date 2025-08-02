# Development-focused functions and aliases

# Project management
proj() {
    local project_dir="${PROJECT_DIR:-$HOME/projects}"
    if [[ $# -eq 0 ]]; then
        # List projects
        echo "Available projects:"
        find "$project_dir" -maxdepth 2 -name ".git" -type d | sed "s|$project_dir/||;s|/.git||" | sort
    else
        # Navigate to project
        local target="$project_dir/$1"
        if [[ -d "$target" ]]; then
            cd "$target"
        else
            echo "Project '$1' not found in $project_dir"
            return 1
        fi
    fi
}

# Quick project creation
mkproj() {
    local name="$1"
    local project_dir="/home/www"
    
    if [[ -z "$name" ]]; then
        echo "Usage: mkproj <project-name>"
        return 1
    fi
    
    local target="$project_dir/$name"
    sudo mkdir -p "$target"
    sudo chown "$USER:www" "$target"
    cd "$target"
    git init
    
    # Create basic project structure
    echo "# $name" > README.md
    echo "node_modules/" > .gitignore
    echo ".env" >> .gitignore
    echo "*.log" >> .gitignore
    
    # Set group ownership for all created files
    sudo chown -R "$USER:www" "$target"
    
    echo "Created project: $name in $project_dir"
}

# Development server shortcuts
serve() {
    local port="${1:-8000}"
    if command -v python3 >/dev/null 2>&1; then
        echo "Starting Python HTTP server on port $port..."
        python3 -m http.server "$port"
    elif command -v python >/dev/null 2>&1; then
        echo "Starting Python HTTP server on port $port..."
        python -m SimpleHTTPServer "$port"
    elif command -v node >/dev/null 2>&1; then
        echo "Starting Node.js HTTP server on port $port..."
        npx http-server -p "$port"
    else
        echo "No HTTP server available (install python3 or node)"
        return 1
    fi
}

# Git workflow shortcuts
gwork() {
    # Start working on a feature branch
    local branch="$1"
    if [[ -z "$branch" ]]; then
        echo "Usage: gwork <branch-name>"
        return 1
    fi
    
    git checkout -b "$branch" || git checkout "$branch"
    git pull origin main
    echo "Working on branch: $branch"
}

gfinish() {
    # Finish work on current branch
    local current_branch=$(git branch --show-current)
    
    if [[ "$current_branch" == "main" || "$current_branch" == "master" ]]; then
        echo "Cannot finish work on main/master branch"
        return 1
    fi
    
    echo "Finishing work on: $current_branch"
    git add .
    git commit -m "feat: work in progress on $current_branch" || true
    git push -u origin "$current_branch"
    
    echo "Branch pushed. Create PR when ready:"
    if command -v gh >/dev/null 2>&1; then
        gh pr create --draft || echo "Run 'gh pr create' manually when ready"
    fi
}

# Code review helpers
review() {
    local branch="${1:-main}"
    echo "Reviewing changes against $branch..."
    
    if command -v delta >/dev/null 2>&1; then
        git diff "$branch"...HEAD | delta
    else
        git diff "$branch"...HEAD
    fi
}

conflicts() {
    echo "Files with merge conflicts:"
    git diff --name-only --diff-filter=U
    
    echo -e "\nTo resolve conflicts:"
    echo "1. Edit the files above"
    echo "2. Run: git add <file>"
    echo "3. Run: git commit"
}

# Testing shortcuts
test-watch() {
    if [[ -f "package.json" ]] && command -v npm >/dev/null 2>&1; then
        npm test -- --watch
    elif [[ -f "Cargo.toml" ]] && command -v cargo >/dev/null 2>&1; then
        cargo watch -x test
    elif [[ -f "pytest.ini" || -f "setup.py" ]] && command -v pytest >/dev/null 2>&1; then
        pytest-watch
    else
        echo "No test runner detected for this project type"
        return 1
    fi
}

# Docker development helpers
drun() {
    # Quick docker run with common options
    local image="$1"
    shift
    docker run --rm -it -v "$PWD:/workspace" -w "/workspace" "$image" "$@"
}

dexec() {
    # Execute command in running container
    local container="$1"
    shift
    docker exec -it "$container" "$@"
}

# Environment management
envs() {
    echo "Environment variables (filtered):"
    env | grep -E "(PATH|HOME|USER|SHELL|EDITOR|LANG|PROJECT)" | sort
}

setenv() {
    local file="${1:-.env}"
    if [[ -f "$file" ]]; then
        echo "Loading environment from $file..."
        set -a
        source "$file"
        set +a
        echo "Environment loaded"
    else
        echo "Environment file $file not found"
        return 1
    fi
}

# Code formatting
fmt() {
    if [[ -f "package.json" ]] && command -v npx >/dev/null 2>&1; then
        echo "Formatting with Prettier..."
        npx prettier --write .
    elif [[ -f "Cargo.toml" ]] && command -v cargo >/dev/null 2>&1; then
        echo "Formatting with rustfmt..."
        cargo fmt
    elif [[ -f "setup.py" ]] && command -v black >/dev/null 2>&1; then
        echo "Formatting with Black..."
        black .
    elif command -v shfmt >/dev/null 2>&1; then
        echo "Formatting shell scripts..."
        find . -name "*.sh" -o -name "*.bash" | xargs shfmt -w
    else
        echo "No formatter detected for this project type"
        return 1
    fi
}

# Dependency management
deps() {
    if [[ -f "package.json" ]]; then
        echo "Node.js dependencies:"
        if command -v npm >/dev/null 2>&1; then
            npm outdated
        fi
    elif [[ -f "Cargo.toml" ]]; then
        echo "Rust dependencies:"
        if command -v cargo >/dev/null 2>&1; then
            cargo outdated 2>/dev/null || echo "Install cargo-outdated: cargo install cargo-outdated"
        fi
    elif [[ -f "requirements.txt" ]]; then
        echo "Python dependencies:"
        if command -v pip >/dev/null 2>&1; then
            pip list --outdated
        fi
    else
        echo "No dependency file detected"
        return 1
    fi
}

# Project statistics
stats() {
    echo "Project Statistics:"
    echo "==================="
    
    if command -v tokei >/dev/null 2>&1; then
        tokei
    elif command -v cloc >/dev/null 2>&1; then
        cloc .
    else
        echo "Lines of code:"
        find . -type f \( -name "*.js" -o -name "*.ts" -o -name "*.py" -o -name "*.rs" -o -name "*.go" \) | xargs wc -l | tail -1
    fi
    
    echo -e "\nGit statistics:"
    echo "Commits: $(git rev-list --count HEAD 2>/dev/null || echo 'N/A')"
    echo "Contributors: $(git shortlog -sn --all 2>/dev/null | wc -l || echo 'N/A')"
    echo "Files tracked: $(git ls-files 2>/dev/null | wc -l || echo 'N/A')"
}