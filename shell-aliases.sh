SYSTEM=$(uname -s|tr a-z A-Z)
if [[ "$SYSTEM" = "LINUX" || "$SYSTEM" =~ "CYGWIN.*" ]]; then
    if [[ -x $(which dircolors) && -r ~/.dircolors ]] ;then
        eval "$(dircolors -b ~/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
fi
if [ "$SYSTEM" = "DRAGONFLY" ]; then
    export LSCOLORS='ExGxFxdxCxDxDxabadaeac'
    alias ls='ls -G'
    alias ctags='/usr/local/bin/exctags'
fi

alias ddate='date +"%T %d-%m-%y"'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

[[ -x $(which vim) ]] && alias vi="$(which vim) -u ~/.vimrc"
[[ -e /usr/bin/vimx ]] && alias vim="/usr/bin/vimx -u ~/.vimrc" && alias vi="/usr/bin/vimx -u ~/.vimrc"

alias ll='ls -lA'
alias la='ls -la'
alias l='ls -CF'

alias ..='cd ..'
alias ...='cd ../..'
alias rmd="rm -rf "
alias history="history -dD"
alias sudo="sudo -E"

alias tmux="tmux -2"
alias cstags="find . \( -not -path './tools/*' -a -not -path './contrib*' -a -not -path './build/.conf*/*'  -a \(  -name '*.c' -o -name '*.cc' -o -name '*.cpp' -o -name '*.hpp' -o -name '*.h' \) \) -print >! cscope.files && cscope -bq && ctags --c++-kinds=+p --fields=+iaS --extra=+q --sort=foldcase -L cscope.files"

alias cstagsclear="rm -v cscope.* tags"

alias cdn='cd ~/notes/'
alias cdp='cd ~/projects/'

alias cdc='cd /cygdrive/c/code/'
alias cdm='cd /cygdrive/c/code/mbsSdk/'
alias cdd='cd ~/dotfiles/'

alias vp="source ~/Projects/tools/virtual-ride/vp-ride.sh"
alias android_env="source ~/Projects/ever-note/android-core/android.env"


alias sdh='svn status|grep ^[?]'
alias sdm="svn status -q"
alias sd="svn diff --diff-cmd kdiff3 -x ' -qall '"
