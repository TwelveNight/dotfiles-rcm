#!/bin/sh
HISTSIZE=1000000
SAVEHIST=1000000
export TERMINAL="kitty"
export BROWSER="firefox"
export EDITOR=nvim
# eval "`pip completion --zsh`"

#zoxide
eval "$(zoxide init zsh --cmd cd)"
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=(bg=none,fg=magenta,bold)

# go
export GOPATH="$HOME/go"
# export GOROOT="$HOME/.go"
export PATH="$PATH:$GOPATH/bin"

# add bob nvim to path
export PATH="$PATH:$HOME/.local/share/bob/nvim-bin"

# add toolbox scripts to path
export PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts"

# eval pyenv virtualenv to path
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
