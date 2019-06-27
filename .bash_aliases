export WIN=/c/Users/lmatter
export BACK=$WIN/Desktop/Backup
export DOCKER_USER=lmatter
export EDITOR=vim
export VISUAL=vim
#
#export GOPATH=$WIN/go  # manditor to set this
export GOPATH=~/go  # manditor to set this
export GOROOT=~/.local/go
#
export CDPATH=.:$GOPATH/src/github.com/ContextLogic/:$GOPATH/src/github.com/lmatter/.:$GOPATH/src/github.com/.
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
alias vi='vim'
alias python='python3'
alias homeon='ssh -f -N homeon'
alias homeoff='ssh -T -O "exit" homeoff'

#
# Leave the PATH for last so it can use other Vars.
export PATH=$HOME/.local/bin:$GOROOT/bin:$GOPATH/bin:$PATH

# If "command not found" happens, try to ssh into "command"
save_function() {
    local ORIG_FUNC=$(declare -f $1)
    local NEWNAME_FUNC="$2${ORIG_FUNC#$1}"
    eval "$NEWNAME_FUNC"
}

save_function command_not_found_handle super_cnf

get_hosts () {
  # tr is to deal with multiple hostnames on the same line
  grep -w -i Host ~/.ssh/config | sed 's/Host //' |tr [:space:] '\n'
}

command_not_found_handle ()
{
    if get_hosts | grep -q -x $1 ; then
        ssh $1
    else
        super_cnf $1
    fi
}

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

PROMPT_DIRTRIM=2
#PS1="\u@\h:\w\[\$(branch_color)\]\$(__git_ps1)\[\e[0m\]\$ "
PS1="\[\e[01;32m\]\u@\h\[\e[00m\]:\[\e[01;34m\]\w\[\$(branch_color)\]\$(__git_ps1)\[\e[00m\]\$ "

export DOCKER_HOST=tcp://localhost:2375
prettyjson_s() {
    echo "$1" | python -m json.tool
}

prettyjson_f() {
    python -m json.tool "$1"
}

prettyjson_w() {
    curl "$1" | python -m json.tool
}
