# set -x
# set -e
# setopt XTRACE VERBOSE

zmodload -F zsh/complist
autoload -Uz vcs_info
autoload -Uz colors zsh/terminfo
autoload -Uz compinit && compinit

# use gnu emacas
bindkey -e
bindkey -r "^L"

# disable XON/XOFF flow control (^s/^q)
stty -ixon
unsetopt beep
setopt noclobber
setopt autocd notify
setopt interactive_comments
setopt complete_in_word
setopt extendedglob
setopt promptsubst
# unsetopt extendedglob
# unsetopt nomatch

local _have_US=$(locale -a|grep -i en_US.UTF8)
if [ $? -eq 0 ] ; then
    export LC_ALL="en_US.UTF-8"
fi

export TIMEFMT=$'\nreal %E\nuser %U\nsys  %S'

local where_vim=$(which vim)
if [ $? -eq 0 ]; then
    export EDITOR=${where_vim}
    export VISUAL=${where_vim}
fi

export MYSQL_PS1="\u@\h [\d]> "
export SVN_EDITOR=$EDITOR
[[ -e ~/.zsh/kdiff3_launcher.sh ]] &&  export SVN_MERGE=~/.zsh/kdiff3_launcher.sh

export GIT_AUTHOR_NAME="$(/usr/bin/git config user.name)"
export GIT_AUTHOR_EMAIL="$(/usr/bin/git config user.email)"
export GIT_COMMITTER_NAME="${GIT_AUTHOR_NAME}"
export GIT_COMMITTER_EMAIL="${GIT_AUTHOR_EMAIL}"

HISTFILE=$HOME/.history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
setopt extended_history
setopt appendhistory
setopt incappendhistory
setopt nosharehistory
# to echo last !!
# setopt hist_verify
setopt hist_save_no_dups
setopt hist_find_no_dups
setopt hist_no_store
# setopt hist_reduce_blanks
setopt hist_allow_clobber
setopt no_hist_beep
#setopt inc_append_history
#setopt hist_expire_dups_first


# how to break string into words for zle(zsh line editor)
WORDCHARS='*?_[]~=&;!#$%^(){}'

##########################################
#            compleation
##########################################

zstyle ':completion:*' completer _complete _ignored
# zstyle :compinstall filename '/home/chris/.zshrc'

#zstyle ':completion:::::' completer _complete _approximate
zstyle    ':completion::complete:*' use-cache 1
zstyle    ':completion:*' use-cache on
zstyle    ':completion:*' cache-path ~/.zsh/cache
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX + $#SUFFIX) / 3 )) )'
zstyle    ':completion:*:descriptions' format "- %d -"
zstyle    ':completion:*:corrections' format "- %d - (errors %e})"
zstyle    ':completion:*:default' list-prompt '%S%M matches%s'
zstyle    ':completion:*' group-name ''
zstyle    ':completion:*:manuals' separate-sections true
zstyle    ':completion:*:manuals.(^1*)' insert-sections true
zstyle    ':completion:*' menu select
zstyle    ':completion:*' verbose yes


zstyle    ':completion:*:kill:*' ignore-line yes
zstyle    ':completion:*:*:kill:*' menu yes select
zstyle    ':completion:*:kill:*' force-list always
zstyle    ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle    ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle -e ':completion::*:*:*:hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'


# enable color support of ls and also add handy aliases
[[ -f ~/.lscolors ]] && source ~/.lscolors

##########################################
#                aliases
##########################################
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
if [ "$SYSTEM" = "DragonFly" ]; then
    alias ls='ls -G'
fi

alias ddate='date +"%T %d-%m-%y"'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
[[ -x $(which vim) ]] && alias vi="$(which vim) -u ~/.vimrc"
[[ -e /usr/bin/vimx ]] && alias vim="/usr/bin/vimx -u ~/.vimrc" && alias vi="/usr/bin/vimx -u ~/.vimrc"
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'

alias ..='cd ..'
alias ...='cd ../..'
alias rmd="rm -rf "
alias ssh='ssh -C'
alias history="history -dD"
alias df="df -h"
alias sudo="sudo -E"

alias bam="./bam"
alias pse="ps aux| grep "
alias eps="ps aux| grep "
alias tmux="tmux -2"
alias xterm='xterm -bg black -fg white'
alias pop=popd
alias pup=pushd
alias cstags="find . -not -path './tools/*' -not -path './contrib*' -not -path './build/.conf*/*' -regex  '.*\.\(c\|cc\|cpp\|h\|hpp\)$'  -print >! cscope.files && cscope -bq && ctags --c++-kinds=+p --fields=+iaS --extra=+q --sort=foldcase -L cscope.files"
alias cstagsclear="rm -v cscope.* tags"

alias cdn='cd ~/Projects/utils/git-dotfiles/'
alias cdp='cd ~/Projects/prototype/mbs-template/'
alias cdb='cd ~/Projects/berserker-ronin/'
alias cdv='cd ~/Projects/editor/vik'
alias cdg='cd ~/Projects/gocode/src/'
alias cdt='cd /home/chris/Projects/tmux-case-insensitive/sourceforge-tmux'

alias cdc="cd /cygdrive/c/cliq/mobilePdBle/"
alias cda="cd /cygdrive/c/aperio_platform/"
alias cdm="cd /cygdrive/c/mbs/"
alias cdgm="cd ~/Projects/mbs-git/"
alias cdd="cd ~/dotfiles/"
alias vp="source ~/Projects/tools/virtual-ride/vp-ride.sh"
alias android_env="source ~/Projects/ever-note/android-core/android.env"
alias ride="/home/chris/Projects/tools/virtual-ride/RIDE.sh"
alias cdkvm="cd /mnt/old-debian/kvm-machines/"
alias cdw="cd ~/Projects/berserker-ronin/command-exec/"
alias cdl="cd ~/Projects/editor/line/"


alias sdh='svn status|grep ^[?]'
alias sdm="svn status -q"
alias sd="svn diff --diff-cmd kdiff3 -x ' -qall '"

##########################################
#             key-bindings
##########################################
bindkey "^X^I" expand-or-complete-prefix

bindkey "^[[1;5D" backward-word #  ctrl left  left arrow
bindkey "^[[1;5C" forward-word # ctrl right arrowa

bindkey '\e[1~' beginning-of-line       # home
bindkey '\e[4~' end-of-line             # end
bindkey "^[[A"  up-line-or-search       # cursor up
bindkey "^[[B"  down-line-or-search     # <ESC>-
bindkey '^x'    history-beginning-search-backward # alternative ways of searching the shell history
bindkey '\e[7~' beginning-of-line       # home
bindkey '\e[8~' end-of-line             # end
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char

export GOPATH=$HOME/Projects/gocode/
function activate_go()
{
    export GOPATH=$HOME/Projects/gocode/
    export OLD_PATH=$PATH
    export PATH=$PATH:$GOPATH/bin
}

function deactivate_go()
{
    export PATH=$OLD_PATH
    export OLD_PATH=
}

fancy-ctrl-z () {
    if [[ $#BUFFER -eq 0 ]]; then
        BUFFER="fg"
        zle accept-line
    else
        zle push-input
        zle clear-screen
    fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

tm() {
    [[ -z "$1" ]] && { echo "usage: tm <session>" >&2; return 1; }
    tmux has -t $1 && tmux attach -t $1 || tmux new -s $1
}

function __tmux-sessions() {
    local expl
    local -a sessions
    sessions=( ${${(f)"$(command tmux list-sessions 2>/dev/null)"}/:[ $'\t']##/:} )
    _describe -t sessions 'sessions' sessions "$@"
}
compdef __tmux-sessions tm


##########################################
#            prompt
##########################################

zstyle ':vcs_info:*' actionformats ' %F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f' '(%s)-[%b|%a]'
zstyle ':vcs_info:*' formats       ' %F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f ' '(%s)-[%b]'
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

function precmd() {
    vcs_info
    PS1_LEN=$(( ${COLUMNS} - 1 ))
    if (($+VIRTUAL_ENV)) ; then
        virtual=$(basename $VIRTUAL_ENV);
        PS1_LEN=$(( $PS1_LEN - ${#virtual}))
    fi
    PS1_LEN=$(( $PS1_LEN - ${#${(%):-%n@%m .%*. :  }} ))
    PS1_LEN=$(( $PS1_LEN - ${#vcs_info_msg_1_} ))
}

set promptsubst
[[ "$terminfo[colors]" -ge 8 ]]; colors

local return_status="%{$fg[red]%}%(?..⏎)%{$reset_color%}"

PROMPT='\
%{$fg[green]%}%(!.%{$fg_bold[white]%}%{$bg[red]%}%n%{$reset_color%}.%n)%{$fg[magenta]%}@\
%{$fg[cyan]%}%m%{$reset_color%}%{$fg_bold[white]%} .%*. \
%{$reset_color%}%{$fg[cyan]%}%$PS1_LEN<...<%~%<< :%{$reset_color%}${vcs_info_msg_0_}
%{$fg[red]%}%!%{$reset_color%} %{$fg[green]%}#-> '
local return_status="%{$fg[red]%}%(?..%?)%{$reset_color%}"
RPROMPT='${return_status}%{$reset_color%}'

function fortune_once() {
    local fortune_cmd=$(which fortune > /dev/null 2>&1)
    if [ $? -ne 0 ] ; then
        return;
    fi
    local fortune_file="/tmp/fortune.day"
    if [ ! -f ${fortune_file} ]; then
        fortune
        touch ${fortune_file}
    fi
    [[ ! -z $(find ${fortune_file} -mtime +1) ]] && (touch ${fortune_file} && fortune) || true;
}

fortune_once
unset GIT_SSH
#echo "The time you enjoy wasting is not wasted time - Bertrand Russell"
# echo -n "Making one brilliant decision and a whole bunch of mediocre ones isn't as
# good as making a whole bunch of generally smart decisions throughout the
# whole process.
#         -- John Carmack "
