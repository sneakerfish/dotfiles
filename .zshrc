# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git git-extras rails zshmarks)

# User configuration

# export PATH="/home/vagrant/.rbenv/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

export PATH=/usr/local/bin:/usr/local/sbin:/opt/local/bin:/opt/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:/Library/TeX/texbin

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PIPENV_PYTHON="$PYENV_ROOT/shims/python"

plugin=(
  pyenv
)

eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# source ".sshagentrc" if present
SSHAGENTRC_FILE=$HOME/.sshagentrc;
if [ -f $SSHAGENTRC_FILE ]; then
  source $SSHAGENTRC_FILE;
fi

# Load any custom init-scripts (the filename *must* end-with "rc")
CUSTOM_INIT_SCRIPTS_DIRECTORY=$HOME/.home_dir/custom;
if [ -d $CUSTOM_INIT_SCRIPTS_DIRECTORY ]; then
  for f in `find "$CUSTOM_INIT_SCRIPTS_DIRECTORY" -type f -o -type l | \grep "rc$"`; do
    source $f;
  done
fi

fpath=(/usr/local/share/zsh-completions $fpath)

# Posgres start and stop
alias pg-start="launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
alias pg-stop="launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"

# Redis
export REDIS_URL=http://127.0.0.1:6379/

# For Zeus
export DOT_FILES_LOCATION=~

# this is the root folder where all globally installed node packages will  go
export NPM_PACKAGES="/usr/local/npm_packages"
export NODE_PATH=$NODE_PATH:/Users/richard.morello/.asdf/installs/nodejs/9.3.0/.npm/lib/node_modules
# add to PATH
export PATH="$NPM_PACKAGES/bin:/usr/local/share/dotnet:$PATH"
export ASPNETCORE_ENVIRONMENT=Development
export ConfigurationServiceUri=http://10.24.0.138:8888
