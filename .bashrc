
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH
export PREFECT_API_URL=http://richard-ai.local:4200/api
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
# Hand interactive shells to zsh. Non-interactive bash (scp, rsync, ssh host cmd)
# also reads .bashrc on Debian/Ubuntu, and exec'ing zsh there breaks them.
if [[ $- == *i* ]] && command -v zsh >/dev/null 2>&1; then
  exec zsh
fi
