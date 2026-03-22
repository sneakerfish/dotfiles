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

# Environment variables
# Pyenv (commented out - using uv instead)
# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"
# export PIPENV_PYTHON="$PYENV_ROOT/shims/python"
export PATH="/usr/local/sbin:/usr/local/opt/mysql-client/bin:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Aliases
alias emacs='emacs -nw'

# Pyenv initialization (commented out - using uv instead)
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

# Docker completions
fpath=(/Users/richardmorello/.docker/completions $fpath)
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
export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"
export JAVA_HOME=$(/usr/libexec/java_home -v 21)

# uv - Python package manager (replaces pyenv/virtualenv)
. "$HOME/.local/bin/env"
export PATH="$HOME/.local/bin:$PATH"
# uv end

# pnpm
export PNPM_HOME="/Users/richardmorello/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
