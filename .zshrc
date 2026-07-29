# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"

# Theme - robbyrussell shows git branch by default
ZSH_THEME="robbyrussell"

# Plugins - timer plugin shows execution time for commands
plugins=(
  git
  timer
  z
  extract
  sudo
  docker
  docker-compose
  python
  jsontools
  colored-man-pages
)

source $ZSH/oh-my-zsh.sh

# Detect OS
case "$(uname -s)" in
  Darwin)
    IS_MACOS=true
    IS_LINUX=false
    ;;
  Linux)
    IS_MACOS=false
    IS_LINUX=true
    ;;
esac

# Environment variables

# macOS-specific paths
if $IS_MACOS; then
  export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
fi

# Bun
export BUN_INSTALL="$HOME/.bun"
[ -d "$BUN_INSTALL/bin" ] && export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Aliases
alias emacs='emacs -nw'

# Docker completions (OS-specific paths)
if $IS_MACOS; then
  [ -d "$HOME/.docker/completions" ] && fpath=($HOME/.docker/completions $fpath)
fi
# Linux uses system completions in /usr/share/zsh/vendor-completions (auto-loaded)
autoload -Uz compinit
compinit

# SSH Agent - start once per session and cache key
if [ -z "$SSH_AUTH_SOCK" ]; then
  # Check if agent is already running
  if [ -f ~/.ssh-agent-info ]; then
    source ~/.ssh-agent-info > /dev/null
  fi

  # Test if agent is responsive
  if ! ssh-add -l > /dev/null 2>&1; then
    # Start new agent
    eval "$(ssh-agent -s)" > /dev/null
    echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" > ~/.ssh-agent-info
    echo "export SSH_AGENT_PID=$SSH_AGENT_PID" >> ~/.ssh-agent-info

    # Add default key - will prompt for passphrase once
    ssh-add ~/.ssh/id_rsa 2>/dev/null
  fi
fi

# Java configuration (OS-specific)
if $IS_MACOS; then
  export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"
  if command -v /usr/libexec/java_home &> /dev/null; then
    export JAVA_HOME=$(/usr/libexec/java_home -v 21 2>/dev/null)
  fi
elif $IS_LINUX; then
  # Use Java 21 on Linux (for Jenkins, etc.)
  if [ -d "/usr/lib/jvm/java-21-openjdk-amd64" ]; then
    export JAVA_HOME="/usr/lib/jvm/java-21-openjdk-amd64"
    export PATH="$JAVA_HOME/bin:$PATH"
  fi
fi

# uv - Python package manager (replaces pyenv/virtualenv)
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
export PATH="$HOME/.local/bin:$PATH"
# uv end

# Add npm-global to PATH
export PATH="$HOME/.npm-global/bin:$PATH"

# pnpm
if $IS_MACOS; then
  export PNPM_HOME="/Users/richardmorello/Library/pnpm"
elif $IS_LINUX; then
  export PNPM_HOME="$HOME/.local/share/pnpm"
fi
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Host-specific endpoints (Prefect, Ollama) live outside this repo, which is
# public — they are tailnet addresses. Copy .dotfiles.local.example to
# ~/.dotfiles.local and fill in per machine.
[ -f "$HOME/.dotfiles.local" ] && source "$HOME/.dotfiles.local"

# OpenClaw Completion (Linux only — not present/exposed on macOS)
if $IS_LINUX; then
  source "/home/rmorello/.openclaw/completions/openclaw.zsh"
fi

# ROCm (Linux only)
if $IS_LINUX; then
  export PATH="/opt/rocm/bin:$PATH"
  export LD_LIBRARY_PATH="/opt/rocm/lib:$LD_LIBRARY_PATH"
fi
