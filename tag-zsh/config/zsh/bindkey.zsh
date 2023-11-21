# autosuggest-accept
bindkey '^f' autosuggest-accept

#history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^p' history-substring-search-up
bindkey '^n' history-substring-search-down

#sudo TODO
# bindkey -M emacs '^S' sudo-command-line
# bindkey -M vicmd '^S' sudo-command-line
# bindkey -M viins '^S' sudo-command-line
