#!/bin/sh
HISTSIZE=1000000
SAVEHIST=1000000
export TERMINAL="kitty"
export BROWSER="brave"
export EDITOR=nvim
# eval "`pip completion --zsh`"

#zoxide
eval "$(zoxide init zsh --cmd cd)"
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=(bg=none,fg=magenta,bold)


# go
export GOPATH="$HOME/go"
export GOROOT="$HOME/.go"
export PATH="$PATH:$GOPATH/bin"



