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
# FIXME: on start of the prompt I have variable lenght string like
#           git branch, error num 
#           this gives problems when comparing string output
#           move that info higher line
#           but this will mean more complicated calculation 
#           etc
function fancy_precmd() {
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
        virtual=$(basename $VIRTUAL_ENV);
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
    autoload -U add-zsh-hook
    add-zsh-hook precmd fancy_precmd

    if [[ "$terminfo[colors]" -ge 8 ]]; then
        colors
    fi

    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
        eval PR_$color='%{%b$fg[${(L)color}]%}'
        eval PR_LIGHT_$color='%{%B$fg[${(L)color}]%}'
        (( count = $count + 1 ))
    done
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
    if [ "${LC_ALL: -5}" = "UTF-8" ] ; then
        PR_SET_CHARSET=""
        PR_SHIFT_IN=""
        PR_SHIFT_OUT=""
        PR_HBAR=$'\u2500'
        PR_ULCORNER=$'\u250c'
        PR_LLCORNER=$'\u2514'
        PR_LRCORNER=$'\u2514'
        PR_URCORNER=$'\u2510'
    elif [ "${PR_SET_CHARSET}" = "%{%}" ] ; then
        PR_SET_CHARSET=""
        PR_SHIFT_IN=""
        PR_SHIFT_OUT=""
        PR_HBAR='-'
        PR_ULCORNER='|'
        PR_LLCORNER='|'
        PR_LRCORNER='|'
        PR_URCORNER='|'
    fi


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
$PR_LIGHT_BLUE ${vcs_info_msg_0_}%(?..$PR_LIGHT_RED%?)$PR_BLUE\
$PR_BR_CLOSE\
$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_CYAN$PR_SHIFT_IN$PR_HBAR$PR_SHIFT_OUT\
$PR_NO_COLOUR'

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
    prompt=$(cat ~/.zsh_prompt)
    [[ $prompt == 'fancy_prompt' ]] && fancy_prompt || true;
    [[ $prompt == 'simple_prompt' ]] && simple_prompt || true;
}


function swap_prompt() {
    case $(cat ~/.zsh_prompt) in
        'simple_prompt') echo "fancy_prompt"  >! ~/.zsh_prompt ;;
        'fancy_prompt')  echo "simple_prompt" >! ~/.zsh_prompt ;;
        *) echo "fancy_prompt" >! ~/.zsh_prompt ;;
    esac

    use_prompt
}

# use_prompt
