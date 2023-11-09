
# SET RANGER SELFCONFIG #
set -g -x RANGER_LOAD_DEFAULT_RC = FALSE

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
