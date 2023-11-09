### ADDING TO THE PATH
# First line removes the path; second line sets it.  Without the first line,
# your path gets massive and fish becomes very slow.
set -e fish_user_paths
set -U fish_user_paths $HOME/.bin $HOME/.local/bin $HOME/Applications $fish_user_paths



### EXPORT ###
set fish_greeting # Supresses fish's intro message
# set TERM xterm-256color # Sets the terminal type
set -g -x TERM xterm-kitty
set -x EDITOR nvim # $EDITOR use nvim in terminal
set -x VISUAL nvim # $VISUAL use nvim in GUI mode



### SET MANPAGER
### Uncomment only one of these!

### "bat" as manpager
#set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

### "vim" as manpager
# set -x MANPAGER '/bin/bash -c "vim -MRn -c \"set buftype=nofile showtabline=0 ft=man ts=8 nomod nolist norelativenumber nonu noma\" -c \"normal L\" -c \"nmap q :qa<CR>\"</dev/tty <(col -b)"'

### "nvim" as manpager
set -x MANPAGER "nvim -c 'set ft=man' -"

### SET EITHER DEFAULT EMACS MODE OR VI MODE ###
function fish_user_key_bindings
    #先用默认的吧,vi还没学
    fish_default_key_bindings
    # fish_vi_key_bindings
end
### END OF VI MODE ###



### SPARK ###
set -g spark_version 1.0.0

complete -xc spark -n __fish_use_subcommand -a --help -d "Show usage help"
complete -xc spark -n __fish_use_subcommand -a --version -d "$spark_version"
complete -xc spark -n __fish_use_subcommand -a --min -d "Minimum range value"
complete -xc spark -n __fish_use_subcommand -a --max -d "Maximum range value"

function spark -d "sparkline generator"
    if isatty
        switch "$argv"
            case {,-}-v{ersion,}
                echo "spark version $spark_version"
            case {,-}-h{elp,}
                echo "usage: spark [--min=<n> --max=<n>] <numbers...>  Draw sparklines"
                echo "examples:"
                echo "       spark 1 2 3 4"
                echo "       seq 100 | sort -R | spark"
                echo "       awk \\\$0=length spark.fish | spark"
            case \*
                echo $argv | spark $argv
        end
        return
    end

    command awk -v FS="[[:space:],]*" -v argv="$argv" '
        BEGIN {
            min = match(argv, /--min=[0-9]+/) ? substr(argv, RSTART + 6, RLENGTH - 6) + 0 : ""
            max = match(argv, /--max=[0-9]+/) ? substr(argv, RSTART + 6, RLENGTH - 6) + 0 : ""
        }
        {
            for (i = j = 1; i <= NF; i++) {
                if ($i ~ /^--/) continue
                if ($i !~ /^-?[0-9]/) data[count + j++] = ""
                else {
                    v = data[count + j++] = int($i)
                    if (max == "" && min == "") max = min = v
                    if (max < v) max = v
                    if (min > v ) min = v
                }
            }
            count += j - 1
        }
        END {
            n = split(min == max && max ? "▅ ▅" : "▁ ▂ ▃ ▄ ▅ ▆ ▇ █", blocks, " ")
            scale = (scale = int(256 * (max - min) / (n - 1))) ? scale : 1
            for (i = 1; i <= count; i++)
                out = out (data[i] == "" ? " " : blocks[idx = int(256 * (data[i] - min) / scale) + 1])
            print out
        }
    '
end
### END OF SPARK ###



### FUNCTIONS ###
# Spark functions

# 查看文件中字母的分布
function letters
    cat $argv | awk -vFS='' '{for(i=1;i<=NF;i++){ if($i~/[a-zA-Z]/) { w[tolower($i)]++} } }END{for(i in w) print i,w[i]}' | sort | cut -c 3- | spark | lolcat
    printf '%s\n' abcdefghijklmnopqrstuvwxyz ' ' | lolcat
end

# 查看作者的提交分布
function commits
    git log --author="$argv" --format=format:%ad --date=short | uniq -c | awk '{print $1}' | spark | lolcat
end

# 绑定上一个命令 bang 命令到 ! 上
# Functions needed for !! and !$
function __history_previous_command
    switch (commandline -t)
        case "!"
            commandline -t $history[1]
            commandline -f repaint
        case "*"
            commandline -i !
    end
end

function __history_previous_command_arguments
    switch (commandline -t)
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end
# The bindings for !! and !$
if [ "$fish_key_bindings" = fish_vi_key_bindings ]
    bind -Minsert ! __history_previous_command
    bind -Minsert '$' __history_previous_command_arguments
else
    bind ! __history_previous_command
    bind '$' __history_previous_command_arguments
end

# Function for creating a backup file
# ex: backup file.txt
# result: copies file as file.txt.bak
function backup --argument filename
    cp $filename $filename.bak
end

# Function for copying files and directories, even recursively.
# ex: copy DIRNAME LOCATIONS
# result: copies the directory and all of its contents.
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
        set from (echo $argv[1] | trim-right /)
        set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end

# Function for printing a column (splits input on whitespace)
# ex: echo 1 2 3 | coln 3
# output: 3
function coln
    while read -l input
        echo $input | awk '{print $'$argv[1]'}'
    end
end

# Function for printing a row
# ex: seq 3 | rown 3
# output: 3
function rown --argument index
    sed -n "$index p"
end

# Function for ignoring the first 'n' lines
# ex: seq 10 | skip 5
# results: prints everything but the first 5 lines
function skip --argument n
    tail +(math 1 + $n)
end

# Function for taking the first 'n' lines
# ex: seq 10 | take 5
# results: prints only the first 5 lines
function take --argument number
    head -$number
end

# Function for org-agenda
function org-search -d "send a search string to org-mode"
    set -l output (/usr/bin/emacsclient -a "" -e "(message \"%s\" (mapconcat #'substring-no-properties \
        (mapcar #'org-link-display-format \
        (org-ql-query \
        :select #'org-get-heading \
        :from  (org-agenda-files) \
        :where (org-ql--query-string-to-sexp \"$argv\"))) \
        \"
    \"))")
    printf $output
end

### END OF FUNCTIONS ###



### AUTOCOMPLETE AND HIGHLIGHT COLORS ###
# set fish_color_normal brmagenta
# set fish_color_autosuggestion '#7d7d7d'
# set fish_color_command brblue
# set fish_color_error '#ff6c6b'
# set fish_color_param brcyan

# # 设置建议文本的颜色（灰色）
# set fish_color_autosuggestion '#5f5f5f'
#
# # 设置命令文本的颜色（青色）
# set fish_color_command '#00afaf'
#
# # 设置注释文本的颜色（绿色）
# set fish_color_comment '#87af87'
#
# # 设置当前工作目录的颜色（紫色）
# set fish_color_cwd '#d75f87'
#
# # 恢复默认文本颜色
# set fish_color_end normal
#
# # 设置错误消息的颜色（亮红色）
# set fish_color_error '#ff5f5f'
#
# # 设置Escape代码的颜色（橙色）
# set fish_color_escape_escape '#ff8700'
#
# # 设置当前历史记录项的颜色（深红色）
# set fish_color_history_current '#d70000'
#
# # 设置操作符的颜色（橙色）
# set fish_color_operator '#ffaf5f'
#
# # 设置参数的颜色（蓝绿色）
# set fish_color_param '#5fafd7'
#
# # 恢复默认文本颜色
# set fish_color_normal normal
#
# # 设置引号中的文本颜色（棕色）
# set fish_color_quote '#d7af87'
#
# # 设置重定向符的颜色（亮黄色）
# set fish_color_redirection '#ffaf00'
#
# # 设置搜索匹配项的颜色（粉色）
# set fish_color_search_match '#d75faf'
#
# # 设置选择文本的颜色（蓝色）
# set fish_color_selection '#005fd7'
#
# # 设置命令完成的颜色（绿色）
# set fish_color_tab_complete '#00d700'
#
# # 设置有效路径的颜色（深绿色）
# set fish_color_valid_path '#5fd700'


### ALIASES ###
# \x1b[2J   <- clears tty
# \x1b[1;1H <- goes to (1, 1) (start)
alias clear='echo -en "\x1b[2J\x1b[1;1H" ; echo; echo; seq 1 (tput cols) | sort -R | spark | lolcat; echo; echo'

# 1password-cli
op completion fish | source

# undefind
alias mk='mkdir'
alias unrar='unrar x'

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# vim
alias vim='nvim'
alias vi='nvim'

# Changing "ls" to "exa"
# alias ls='exa -al --color=always --group-directories-first' # my preferred listing
alias ls='exa  --icons --color=always --group-directories-first'
alias la='exa -a --icons --color=always --group-directories-first' # all files and dirs(including hidden)
alias ll='exa -hagl --icons --git --color=always --group-directories-first' # long format
alias lt='exa -aT --color=always --group-directories-first' # tree listing
alias l.='exa -a --icons | grep -E "^\."' # show only hidden files

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

# ps
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

# git
alias lg='lazygit'
alias addup='git add -u'
alias addall='git add .'
alias branch='git branch'
alias checkout='git checkout'
alias clone='git clone'
alias commit='git commit -m'
alias fetch='git fetch'
alias pull='git pull origin'
alias push='git push origin'
alias tag='git tag'
alias newtag='git tag -a'

# get error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# switch between shells
# I do not recommend switching default SHELL from bash.
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Now log out.'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Now log out.'"
alias tofish="sudo chsh $USER -s /bin/fish && echo 'Now log out.'"

#docker
alias dk='docker'
alias dki='docker images'
alias dkc='docker container ls'
alias dkr='docker run'
alias dke='docker exec -it'
alias dkp='docker ps'
alias dkpa='docker ps -a'
alias dkrmi='docker rmi'
alias dkrm='docker rm'
alias dkb='docker build'
alias dkt='docker tag'
alias dkl='docker logs'
alias dklf='docker logs -f'

# clear
alias cl='clear'

# ranger
alias ra='ranger'

### PROMPT ###
# This is a theme called 'sashimi'
function fish_prompt
    set -l last_status $status
    set -l cyan (set_color -o cyan)
    set -l yellow (set_color -o yellow)
    set -g red (set_color -o red)
    set -g blue (set_color -o blue)
    set -l green (set_color -o green)
    set -g normal (set_color normal)

    set -l ahead (_git_ahead)
    set -g whitespace ' '

    if test $last_status = 0
        set initial_indicator "$green◆"
        set status_indicator "$normal❯$cyan❯$green❯"
    else
        set initial_indicator "$red✖ $last_status"
        set status_indicator "$red❯$red❯$red❯"
    end
    set -l cwd $cyan(basename (prompt_pwd))

    if [ (_git_branch_name) ]

        if test (_git_branch_name) = master
            set -l git_branch (_git_branch_name)
            set git_info "$normal git:($red$git_branch$normal)"
        else
            set -l git_branch (_git_branch_name)
            set git_info "$normal git:($blue$git_branch$normal)"
        end

        if [ (_is_git_dirty) ]
            set -l dirty "$yellow ✗"
            set git_info "$git_info$dirty"
        end
    end

    # Notify if a command took more than 5 minutes
    if [ "$CMD_DURATION" -gt 300000 ]
        echo The last command took (math "$CMD_DURATION/1000") seconds.
    end

    echo -n -s $initial_indicator $whitespace $cwd $git_info $whitespace $ahead $status_indicator $whitespace
end

function _git_ahead
    set -l commits (command git rev-list --left-right '@{upstream}...HEAD' 2>/dev/null)
    if [ $status != 0 ]
        return
    end
    set -l behind (count (for arg in $commits; echo $arg; end | grep '^<'))
    set -l ahead (count (for arg in $commits; echo $arg; end | grep -v '^<'))
    switch "$ahead $behind"
        case '' # no upstream
        case '0 0' # equal to upstream
            return
        case '* 0' # ahead of upstream
            echo "$blue↑$normal_c$ahead$whitespace"
        case '0 *' # behind upstream
            echo "$red↓$normal_c$behind$whitespace"
        case '*' # diverged from upstream
            echo "$blue↑$normal$ahead $red↓$normal_c$behind$whitespace"
    end
end

function _git_branch_name
    echo (command git symbolic-ref HEAD 2>/dev/null | sed -e 's|^refs/heads/||')
end

function _is_git_dirty
    echo (command git status -s --ignore-submodules=dirty 2>/dev/null)
end
### END OF PROMPT #### SET EDITOR #


# SET RANGER SELFCONFIG #
set -g -x RANGER_LOAD_DEFAULT_RC = FALSE

# SET EDITOR #
set -x EDITOR

# SET RANGER SELFCONFIG #
set -g -x RANGER_LOAD_DEFAULT_RC = FALSE

### PATH ###

# ADD NPM PATH #
set -x PATH /home/night/.npm-global/bin $PATH

# ADD CARGO PATH #
set -x PATH /home/night/.cargo/bin $PATH

# ADD PYENV PATH #
set -g -x PYENV_ROOT $HOME/.pyenv
set -g -x PATH $PYENV_ROOT/shims $PATH

# ADD RUST PATH #
set -g -x PATH $HOME/.local/share/gem/ruby/3.0.0/bin $PATH

# ADD GO PATH #
set -g -x PATH $HOME/go/bin $PATH

# ADD SSH_AUTH_SOCK
set -g -x SSH_AUTH_SOCK $HOME/.1password/agent.sock

# ADD aliyunpan PATH #
set -g -x ALIYUNPAN_CONFIG_DIR $HOME/aliyunpan


# ADD db pssword
set -g -x PASSPORT_PASSWORD GostdGVkX1
set -g -x LABOR_PASSWORD ApQyeA4PLzWikcUs6Wwp

# fctx5
set -g -x GTK_IM_MODULE fcitx5
set -g -x QT_IM_MODULE fcitx5
set -g -x SDL_IM_MODULE fcitx5
set -g -x XMODIFIERS @im=fcitx5
set -g -x GLFW_IM_MODULE ibus

# Wayland
# GTK后端为 wayland和x11,优先wayland
set -g -x GDK_BACKEND "wayhland,x11"
# 解决QT程序缩放问题
set -g -x QT_AUTO_SCREEN_SCALE_FACTOR 1
# QT使用wayland和gtk
set -g -x QT_QPA_PLATFORM "wayland;xcb"
set -g -x QT_WAYLAND_DISABLE_WINDOWDECORATION 1
# 使用qt5ct软件配置QT程序外观
set -g -x QT_QPA_PLATFORMTHEME qt5ct
# 一些游戏使用wayland
set -g -x QT_QPA_PLATFORMTHEME qt5ct
# 解决java程序黑屏问题
set -g -x _JAVA_AWT_WM_NONREPARENTING 1



# dispay
# set -g -x DISPLAY :0
### END ###

if status --is-interactive
    # Your interactive shell commands here
    pyenv init - | source
end

thefuck --alias | source
