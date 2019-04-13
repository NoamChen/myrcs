# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

if [ -f ~/.git-prompt ]; then
	source ~/.git-prompt
fi

if [ -f ~/.acd_func ]; then
	source ~/.acd_func
fi

if [ -f ~/.bashrc.local ]; then
	source ~/.bashrc.local
fi


# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
HISTCONTROL=ignoredups:erasedups
HISTIGNORE='&:ls:ll:la:cd:exit:clear:history'
EDITOR=vim

export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
#case "$TERM" in
#    xterm-color) color_prompt=yes;;
#esac

color_prompt=yes;

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] $(__git_ps1 "(%s) " )\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac
#  PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    #alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

#if Running Arch, source the specific file for arch
if [ -f /etc/arch-release ]; then
    . ~/.bash_arch
fi

# Function to use for posting to hastebin
haste() { a=$(cat); curl -X POST -s -d "$a" https://hastebin.com/documents | awk -F '"' '{print "https://hastebin.com/"$4}'; }

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

## COLORED MANUAL PAGES #{{{
    # @see http://www.tuxarena.com/?p=508
    # For colourful man pages (CLUG-Wiki style)
    if $_isxrunning; then
      export PAGER=less
      export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
      export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
      export LESS_TERMCAP_me=$'\E[0m'           # end mode
      export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
      export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
      export LESS_TERMCAP_ue=$'\E[0m'           # end underline
      export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
    fi

#path variable
export PATH=~/bin:$PATH

function cgrep()
{
    find . -name .repo -prune -o -name .git -prune -o -name out -prune -o -type f \( -name '*.c' -o -name '*.cc' -o -name '*.cpp' -o -name '*.h' -o -name '*.hpp' \) \
        -exec grep --color -n "$@" {} +
}

function bbgrep()
{
    find . -name .repo -prune -o -name .git -prune -o -name out -prune -o -type f \( -name '*.bb' -o -name '*.bbappend' -o -name '*.inc' \) \
        -exec grep --color -n "$@" {} +
}

function hgrep()
{
    find . -name .repo -prune -o -name .git -prune -o -name out -prune -o -type f \( -name '*.h' -o -name '*.hpp' \) \
        -exec grep --color -n "$@" {} +
}

function sgrep()
{
    find . -name .repo -prune -o -name .git -prune -o -name out -prune -o -type f \( -name '*.s' -o -name '*.S' \) \
        -exec grep --color -n "$@" {} +
}

function kgrep()
{
    find . -name .repo -prune -o -name .git -prune -o -name out -prune -o -type f \( -name 'Kconfig' \) \
        -exec grep --color -n "$@" {} +
}

function dtgrep()
{
    find . -name .repo -prune -o -name .git -prune -o -name out -prune -o -type f \( -name '*.dts' -o -name '*.dtsi' \) \
        -exec grep --color -n "$@" {} +
}

function mgrep()
{
    find . -name .repo -prune -o -name .git -prune -o -path ./out -prune -o -regextype posix-egrep -iregex '(.*\/Makefile|.*\/Makefile\..*|.*\.make|.*\.mak|.*\.mk)' -type f \
        -exec grep --color -n "$@" {} +
}

function github_latest_release()
{
	curl --silent "https://api.github.com/repos/$1/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")'
}

function fixup()
{
    EDITOR=true git commit --fixup $1 && git rebase -i $1~ --autosquash
}

alias groot='cd $(git root)'
alias cscope_create='find . -name "*.[csh]" >> cscope.files;cscope -b -q'
alias cscope_create_kernel='find . -name "*.[csh]" >> cscope.files;cscope -b -q -k'
alias download='curl -O -J -L'

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
alias whatsmyip='curl -s http://whatismyip.akamai.com/'
alias apt-upgrade='sudo apt-get update && sudo apt-get upgrade --yes  && sudo apt-get auto-remove'


#git aliases
alias gis='git status '
alias gia='git add '
alias gib='git branch '
alias gic='git commit -s -m'
alias gid='git diff'
alias gidc='git diff --cached'
alias gco='git checkout '
#alias gil="git log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short"
alias gil="git log --pretty=format:'%h %ad | %s%d [%an]' --date=short"
#alias gig="git push aosp HEAD:refs/for/communitake"
alias gica='git commit --amend'
alias gir='git rebase -i'
alias girc='git rebase --continue'

#checkpatch
alias chk='~/bin/checkpatch.pl --notree'


#inner func to be used as ssh alias skeleton
function ssh_base {
	local ip=$1
	local username=$2
	local password=$3

	echo "ip: ${ip}"
	echo "un: ${username}"
	echo "pw: ${password}"

	sshpass -p ${password} ssh -o  ServerAliveInterval=60 -o StrictHostKeyChecking=no ${username}@${ip}
}

function rcv_base {
	local ip=$1
	local username=$2
	local password=$3
	local target=$4
	local dir=$5

	echo "ip : ${ip}"
	echo "usr: ${username}"
	echo "pwd: ${password}"
	echo "get: ${target}"
	echo "dst: ${dir}"

	sshpass -p ${password} scp -r -o  ServerAliveInterval=60 -o StrictHostKeyChecking=no ${username}@${ip}:${target} ${dir}
}

function send_base {
	local ip=$1
	local username=$2
	local password=$3
	local target=$4
	local dir=$5

	echo "ip : ${ip}"
	echo "usr: ${username}"
	echo "pwd: ${password}"
	echo "snd: ${target}"
	echo "dst: ${dir}"

	sshpass -p ${password} scp -r -o  ServerAliveInterval=60 -o StrictHostKeyChecking=no ${target} ${username}@${ip}:${dir}
}

function flash_base {
	local rootfs=$1
	local boot=$2

	echo "rtfs: ${rootfs}"
	echo "boot: ${boot}"
	echo

	gunzip ${rootfs}.gz
	sudo fastboot devices
	sudo fastboot flash boot ${boot}
	sudo fastboot flash rootfs ${rootfs}
}

#machines

#ssh
#alias sfr='ssh_base 192.168.6.141 user 123456'

#scp
#alias rif='rcv_base 192.168.6.141 user 123456 /home/user/projects/yocto_fr/out/tmp-rpb-glibc/deploy/images/dragonboard-410c/ .'

#bashrc accessors
alias chb='vi ~/.bashrc'
alias synb='source ~/.bashrc'

#capacity of each dir
alias cap='du -h | sort -rh > space'

#flash
#alias dbf='flash_base rpb-console-image-dragonboard-410c.ext4 boot-dragonboard-410c.img'

#compilation and build
