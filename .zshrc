# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"

# Theme - robbyrussell shows git branch by default
ZSH_THEME="robbyrussell"

# Plugins - timer plugin shows execution time for commands
plugins=(
  git
  pyenv
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
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:/usr/local/sbin:/usr/local/opt/mysql-client/bin:$PATH"
export PIPENV_PYTHON="$PYENV_ROOT/shims/python"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Aliases
alias emacs='emacs -nw'

# Pyenv initialization
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

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
