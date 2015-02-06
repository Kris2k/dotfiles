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
setopt autocd notify
setopt interactive_comments
setopt complete_in_word
setopt extendedglob
setopt promptsubst
# unsetopt extendedglob
# unsetopt nomatch

export TIMEFMT=$'\nreal %E\nuser %U\nsys  %S'
local _drop=$(which vim)
if [ $? -eq 0 ]; then
    export EDITOR=$(which vim)
    export VISUAL=$(which vim)
fi
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

export MYSQL_PS1="\u@\h [\d]> "
export SVN_EDITOR=$EDITOR
[[ -e ~/.zsh/kdiff3_launcher.sh ]] &&  export SVN_MERGE=~/.zsh/kdiff3_launcher.sh

# local current_tty=`tty`
# if [ "${current_tty[6,8]}" = "pts" ] ; then
#     export TERM=xterm-256color
# fi

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
setopt hist_reduce_blanks
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

if [ "$(uname -s)" = "Linux" ]; then
    if [[ -x `which dircolors` && -r ~/.dircolors ]] ;then
        eval "$(dircolors -b ~/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
fi
if [ "$(uname -s)" = "DragonFly" ]; then
    alias ls='ls -G'
fi

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
[[ -x `which vim` ]] && alias vi="$(which vim) -u ~/.vimrc"
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
alias cstags="find . -not -path './contrib*' -not -path './build/.conf*/*' -regex  '.*\.\(c\|cc\|cpp\|h\|hpp\)$'  -print > cscope.files && cscope -bq && ctags --c++-kinds=+p --fields=+iaS --extra=+q --sort=foldcase -L cscope.files"
alias cstagsclear="rm -v cscope.* tags"

alias cdn='cd ~/Projects/utils/git-dotfiles/'
alias cdp='cd ~/Projects/'
alias cdb='cd ~/Projects/berserker-ronin/'
alias cdv='cd ~/Projects/utils/vimfiles/'
alias cdg='cd ~/Projects/gocode/src/'
alias cdt='cd /home/chris/Projects/tmux-case-insensitive/sourceforge-tmux'

alias cdss="cd ~/Projects/kelvatek-server/"
alias cdd="cd ~/dotfiles/"
alias vp="source ~/Projects/tools/virtual-ride/vp-ride.sh"
alias android_env="source ~/Projects/ever-note/android-core/android.env"
alias ride="/home/chris/Projects/tools/virtual-ride/RIDE.sh"
alias cdkvm="cd /mnt/old-debian/kvm-machines/"
alias cdw="cd ~/Projects/berserker-ronin/command-exec/"


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
    sessions=( ${${(f)"$(command tmux list-sessions)"}/:[ $'\t']##/:} )
    _describe -t sessions 'sessions' sessions "$@"
}
compdef __tmux-sessions tm


##########################################
#             simple prompt
##########################################

function simple_prompt() {
    if [ "$color_prompt" = yes ]; then
        PS1=$'%{\e[01;36m%}%n%{\e[01;36m%}%{\e[00m%}@%{\e[00m%}%m:%3c>'
    else
        if [ ${EUID} = 0 ] ; then
            PS1="$(print '%{\e[0;31m%}%n@%m%{\e[0m%}'):$(print '%{\e[0;33m%}%3c%{\e[0m%}')> "
        else
            PS1="$(print '%{\e[0;32m%}%n@%m%{\e[0m%}'):$(print '%{\e[0;33m%}%3c%{\e[0m%}')> "
        fi
        PS2="$(print '%{\e[0;34m%}>%{\e[0m%}')"
    fi
}

##########################################
#             fancy prompt
##########################################

function precmd() {
    # vsc_info position have impact on rendering the prompt
    vcs_info
    local TERMWIDTH
    (( TERMWIDTH = ${COLUMNS} - 1 ))

    ###
    # Truncate the path if it's too long.

    # calculating --- is slow
    PR_FILLBAR=""
    PR_PWDLEN=""

    # local promptsize=${#${(%):---(%n@%m:%l)----()--(%D{%H:%M} %D)}}
    local virtual=
    local virtualsize=0 # ${#virtual}
    if (($+VIRTUAL_ENV)) ; then
        virtual=`basename $VIRTUAL_ENV`;
        virtualsize=${#virtual}
        virtualsize=$((virtualsize+2))
    fi

    local promptsize=${#${(%):---(%n@%m:%l)------(%D{%H:%M} %D)}}
    promptsize=$((promptsize+virtualsize+2))
    local pwdsize=${#${(%):-%~}}

    if [[ "$promptsize + $pwdsize" -gt $TERMWIDTH ]]; then
        ((PR_PWDLEN=$TERMWIDTH - $promptsize))
    else
        PR_FILLBAR="\${(l.(($TERMWIDTH  - ($promptsize + $pwdsize)))..${PR_HBAR}.)}"
    fi

}


function fancy_prompt () {
    setopt promptsubst
    ###
    # See if we can use colors.

    if [[ "$terminfo[colors]" -ge 8 ]]; then
        colors
    fi
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
        eval PR_$color='%{%b$fg[${(L)color}]%}'
        eval PR_LIGHT_$color='%{%B$fg[${(L)color}]%}'
        (( count = $count + 1 ))
    done
    PR_K_GREEN="%b$fg[green]"
    PR_NO_COLOUR="%{$terminfo[sgr0]%}"

    ###
    # See if we can use extended characters to look nicer.

    typeset -A altchar
    set -A altchar ${(s..)terminfo[acsc]}
    PR_SET_CHARSET="%{$terminfo[enacs]%}"
    PR_SHIFT_IN="%{$terminfo[smacs]%}"
    PR_SHIFT_OUT="%{$terminfo[rmacs]%}"
    PR_HBAR=${altchar[q]:--}
    PR_ULCORNER=${altchar[l]:--}
    PR_LLCORNER=${altchar[m]:--}
    PR_LRCORNER=${altchar[j]:--}
    PR_URCORNER=${altchar[k]:--}


    ###
    # Decide if we need to set titlebar text.
    # set term title
    case $TERM in
    xterm*)
        PR_TITLEBAR=$'%{\e]0;%(!.-=*[ROOT]*=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\a%}'
        ;;
    screen*)
        PR_TITLEBAR=$'%{\e_screen \005 (\005t) | %(!.-=[ROOT]=- | .)%n@%m:%~ | ${COLUMNS}x${LINES} | %y\e\\%}'
        ;;
    *)
        PR_TITLEBAR=''
        ;;
    esac


    [[ "${TERM[1,6]}" = "screen" ]] && PR_STITLE=$'%{\ekzsh\e\\%}' || PR_STITLE=''

    PR_BG_HOST=''
    eval PR_BG_ENDHOST='%{%B$bg[default]%}'
    case `hostname` in
        'ENW*'|'SSE*'|'DEMO*'|'CE*')
            eval PR_BG_HOST='%{$bg[red]%}'
            ;;
        'asus-g1s')
            #eval PR_BG_HOST='%{%B$bg[red]%}'
            ;;
    esac
    eval PR_BG_ROOT='%{%B$bg[red]%}'

    ###
    # APM detection

    if which ibam > /dev/null; then
    PR_APM='$PR_RED${${PR_APM_RESULT[(f)1]}[(w)-2]}%%(${${PR_APM_RESULT[(f)3]}[(w)-1]})$PR_LIGHT_BLUE:'
    elif which apm > /dev/null; then
    PR_APM='$PR_RED${PR_APM_RESULT[(w)5,(w)6]/\% /%%}$PR_LIGHT_BLUE:'
    else
    PR_APM=''
    fi
    #FIXME: %c for changes %u for unstaged
    #zstyle ':vcs_info:*:*' check-for-changes true
    # http://physos.com/2010/09/24/my-custom-zsh-prompt/
    zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f'
    zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
    zstyle ':vcs_info:*' formats       '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '

    ###
    # Finally, the prompt.
    PR_BR_OPEN="["
    PR_BR_CLOSE="]"
    ## to test the prompt use print -P
    ## %(?.if_zero.if_not_zero)
    ## http://www.bash2zsh.com/zsh_refcard/refcard.pdf
    ## also=http://zsh.sourceforge.net/Guide/zshguide03.html#l29
    PROMPT='$PR_SET_CHARSET$PR_STITLE${(e)PR_TITLEBAR}\
$PR_CYAN$PR_SHIFT_IN$PR_ULCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT$PR_BLUE\
$PR_BR_OPEN\
$PR_GREEN%(!.${PR_BG_ROOT}ROOT%s.%n)$PR_GREEN@$PR_BG_HOST%m$PR_BG_ENDHOST$PR_GREEN:%l$PR_BLUE\
$PR_BR_CLOSE\
$PR_SHIFT_IN$PR_BLUE$PR_HBAR$PR_HBAR$PR_SHIFT_OUT$PR_BLUE\
$PR_BR_OPEN\
$PR_YELLOW%$PR_PWDLEN<...<%~%<<$PR_BLUE\
$PR_BR_CLOSE\
$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_HBAR${(e)PR_FILLBAR}$PR_BLUE$PR_HBAR$PR_SHIFT_OUT$PR_BLUE\
$PR_BR_OPEN\
%B$PR_LIGHT_GREEN%D{%H:%M} %D$PR_BLUE\
$PR_BR_CLOSE\
$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_URCORNER$PR_SHIFT_OUT\

$PR_CYAN$PR_SHIFT_IN$PR_LLCORNER$PR_BLUE$PR_HBAR$PR_SHIFT_OUT\
$PR_BR_OPEN\
$PR_LIGHT_BLUE\
 ${vcs_info_msg_0_}\
%(?..$PR_LIGHT_RED%?)$PR_BLUE\
$PR_BR_CLOSE$\
PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_NO_COLOUR '

    # for right side prompt uncomment that
    #RPROMPT=' $PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_BLUE$PR_HBAR$PR_SHIFT_OUT\
#($PR_YELLOW%D{%a,%b%d}$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_CYAN$PR_LRCORNER$PR_SHIFT_OUT$PR_NO_COLOUR'

    #  continuation of prompt (when for or unfinished caption etc)
    PS2='$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_BLUE$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT(\
$PR_LIGHT_GREEN%_$PR_BLUE)$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT$PR_NO_COLOUR '
}


## FIXME:  hack local ignore_error=$? is to remove errors from prompt
function use_prompt() {
    [[ ! -f ~/.zsh_prompt ]]  && echo fancy_prompt > ~/.zsh_prompt || true;
    [[ `cat ~/.zsh_prompt` == 'fancy_prompt' ]] && fancy_prompt || true;
    [[ `cat ~/.zsh_prompt` == 'simple_prompt' ]] && simple_prompt || true;
}


function swap_prompt() {
    case `cat ~/.zsh_prompt` in
        'simple_prompt') echo "fancy_prompt"  > ~/.zsh_prompt ;;
        'fancy_prompt')  echo "simple_prompt" > ~/.zsh_prompt ;;
        *) echo "fancy_prompt" > ~/.zsh_prompt ;;
    esac

    use_prompt
}

use_prompt

function fortune_once() {
    if [ -z $(which fortune) ]; then
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
# echo -n "Making one brilliant decision and a whole bunch of mediocre ones isn't as
# good as making a whole bunch of generally smart decisions throughout the
# whole process.
#         -- John Carmack "
