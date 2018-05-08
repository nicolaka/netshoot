cat /etc/motd

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export LS_OPTIONS='--color=auto'


# aliases
alias ls='ls $LS_OPTIONS'


function prompt {
 local BLACK="\[\033[0;30m\]"
 local BLACKBOLD="\[\033[1;30m\]"
 local RED="\[\033[0;31m\]"
 local REDBOLD="\[\033[1;31m\]"
 local GREEN="\[\033[0;32m\]"
 local GREENBOLD="\[\033[1;32m\]"
 local YELLOW="\[\033[0;33m\]"
 local YELLOWBOLD="\[\033[1;33m\]"
 local BLUE="\[\033[0;34m\]"
 local BLUEBOLD="\[\033[1;34m\]"
 local PURPLE="\[\033[0;35m\]"
 local PURPLEBOLD="\[\033[1;35m\]"
 local CYAN="\[\033[0;36m\]"
 local CYANBOLD="\[\033[1;36m\]"
 local WHITE="\[\033[0;37m\]"
 local WHITEBOLD="\[\033[1;37m\]"
 local RESETCOLOR="\[\e[00m\]"

 export PS1="\n$RED\u $PURPLE@ $GREEN\w $RESETCOLOR$GREENBOLD\$(git branch 2> /dev/null)\n $BLUE[\#] 🐳  → $RESETCOLOR"
 export PS2=" | → $RESETCOLOR "
}

function title {
   echo -ne "\033]0;"$*"\007"  
}

prompt

