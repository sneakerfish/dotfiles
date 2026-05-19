
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH
export PREFECT_API_URL=http://richard-ai.local:4200/api
exec zsh

. "$HOME/.local/bin/env"
