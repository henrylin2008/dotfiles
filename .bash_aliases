export WIN=/c/Users/lmatter
export BACK=$WIN/Desktop/Backup
export DOCKER_USER=lmatter
export EDITOR=vim
export VISUAL=vim
export DISPLAY=0:0
#
export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1" 
#
export GOPATH=$WIN/go 
#export GOPATH=~/go  
export GOROOT=~/.local/go
#
export JAVA_HOME=~/.local/jdk
export CDPATH=.:$GOPATH/src/github.com/ContextLogic/it-bizops:$GOPATH/src/github.com/ContextLogic/:$GOPATH/src/github.com/lmatter/.:$GOPATH/src/github.com/.:$WIN
# Bash History
export HISTSIZE=1000000  #infinite
export HISTFILESIZE=1000000  #infinite
export HISTCONTROL=ignoreboth
export HISTIGNORE='ls:bg:fg:history'
export HISTTIMEFORMAT='%F %T '
shopt -s cmdhist 
PROMPT_COMMAND='history -a'
#
alias ls='ls -F'
alias lt='ls -lht |head'
alias vi='vim'
alias python='python3'
alias homeon='ssh -f -N homeon'
alias homeoff='ssh -T -O "exit" homeoff'

#
# Leave the PATH for last so it can use other Vars.
export PATH=$HOME/.local/bin:$GOROOT/bin:$GOPATH/bin:$JAVA_HOME/bin:$PATH

# If "command not found" happens, try to ssh into "command"
save_function() {
    local ORIG_FUNC=$(declare -f $1)
    local NEWNAME_FUNC="$2${ORIG_FUNC#$1}"
    eval "$NEWNAME_FUNC"
}

fn_exists() { test x$(type -t $1) = xfunction; }

if ! fn_exists super_cnf; then
   save_function command_not_found_handle super_cnf

   get_hosts () {
     # tr is to deal with multiple hostnames on the same line
     grep -w -i Host ~/.ssh/config | sed 's/Host //' |tr [:space:] '\n'
   }

   command_not_found_handle ()
   {
       if get_hosts | grep -q -x $1 ; then
           ssh $@
       else
           super_cnf $1
       fi
   }
fi

# Reset
Color_Off='\e[0m'       # Text Reset

# Regular Colors
Red="\e[0;31m"         # Red
Green="\e[0;32m"        # Green

branch_color() {
  if /home/lmatter/.local/bin/git diff --quiet 2>/dev/null >&2;
  then
    color=$Green
  else
    color=$Red
  fi
  echo -ne $color 
}


export DOCKER_HOST=tcp://localhost:2375
prettyjson_s() {
    echo "$1" | python -m json.tool
}

prettyjson_f() {
    python -m json.tool "$1"
}

prettyjson_w() {
    curl "$*" | python -m json.tool
}

if [ -z "$(pgrep ssh-agent)" ]; then
   rm -rf /tmp/ssh-*
   eval $(ssh-agent -s) > /dev/null
   ssh-add ~/.ssh/{id_rsa,github} > /dev/null
else
   export SSH_AGENT_PID=$(pgrep ssh-agent)
   export SSH_AUTH_SOCK=$(find /tmp/ssh-* -name agent.*)
fi
if [ "$TERM" = "linux" ]; then
    echo -en "\e]P0073642" #black
    echo -en "\e]P1DC322F" #darkred
    echo -en "\e]P2859900" #darkgreen
    echo -en "\e]P3B58900" #brown
    echo -en "\e]P4268BD2" #darkblue
    echo -en "\e]P5D33682" #darkmagenta
    echo -en "\e]P62AA198" #darkcyan
    echo -en "\e]P7EEE8D5" #lightgrey
    echo -en "\e]P8002B36" #darkgrey
    echo -en "\e]P9CB4B16" #red
    echo -en "\e]PA586E75" #green
    echo -en "\e]PB657B83" #yellow
    echo -en "\e]PC839496" #blue
    echo -en "\e]PD6C71C4" #magenta
    echo -en "\e]PE93A1A1" #cyan
    echo -en "\e]PFFDF6E3" #white
    clear #for background artifacting
fi

PROMPT_DIRTRIM=2
#PS1="\u@\h:\w\[\$(branch_color)\]\$(__git_ps1)\[\e[0m\]\$ "
PS1="\[\e[01;32m\]\u@\h\[\e[00m\]:\[\e[01;34m\]\w\[\$(branch_color)\]\$(__git_ps1)\[\e[00m\]\$ "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
