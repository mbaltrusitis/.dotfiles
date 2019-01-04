# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

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
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

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
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
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

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        source /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        source /etc/bash_completion
    elif [ -f /usr/local/etc/bash_completion ]; then
        source /usr/local/etc/bash_completion
    fi
fi

# my edits start

# super user bin start
export PATH="/usr/local/sbin:$PATH"

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
	PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
	PATH="$HOME/.local/bin:$PATH"
fi

# set PATH to include cargo-built binaries
if [ -d "$HOME/.cargo/bin" ] ; then
	PATH="$HOME/.cargo/bin:$PATH"
fi

# some FUNctions
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

# mail
export MAILCHECK=60
export MAILPATH="/var/spool/mail/$USER"

# run ssh-agen start
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh-agent-proc
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval "$(<~/.ssh-agent-proc)" 1> /dev/null
fi
# run ssh-agen end

# run gpg-agent start
if [ -z "$(pgrep -u "$USER" gpg-agent)" ]; then
    eval "$(gpg-agent --daemon ~/.gnupg/.gpg-agent-info)"
fi
# run gpg-agent end

# my editor
export EDITOR='/usr/bin/vim'

# base16 shell start
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"
# base16-shell end

# pyenv start
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
# pyenv end

# nodenv start
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"
# noodenv end

# npm start
export NPM_PACKAGES="$HOME/.npm-global"
export PATH="$NPM_PACKAGES/bin:$PATH"
unset -v MANPATH
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
# npm end

# virtualenvwrapper start
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/Projects
export VIRTUALENVWRAPPER_PYTHON=python3
if [ -f $HOME/.local/bin/virtualenvwrapper.sh ]; then
	# Linux
	source $HOME/.local/bin/virtualenvwrapper.sh;
elif [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
	# Darwin
	source /usr/local/bin/virtualenvwrapper.sh;
fi
# virtualenvwrapper end

# pipenv start
eval "$(pipenv --completion)"
# pipenv end

# visuals start
# PS1 nonsense
PS1="\[\e[37m\]"
PS1+="╭╴"
PS1+="\[\e[m\]"
PS1+="\[\e[31m\]"
PS1+="\u"
PS1+="\[\e[m\]"
PS1+="\[\e[37m\]"
PS1+="@"
PS1+="\[\e[m\]"
PS1+="\[\e[31m\]"
PS1+="\h"
PS1+="\[\e[m\]"
PS1+="\[\e[37m\]"
PS1+=" : "
PS1+="\[\e[m\]"
PS1+="\[\e[36m\]"
PS1+="\w"
PS1+="\n"
PS1+="\[\e[31m\]"
PS1+="\[\e[37m\]"
PS1+="╰╴"
PS1+="\[\e[m\]"
PS1+="\[\e[31m\]"
#PS1+="🔥 "
PS1+="🎄 "  # merry christmas
PS1+="\[\e[m\]"

export CLICOLOR=1
export LS_COLORS='di=1;36:fi=0:ln=34:pi=5:so=33:bd=5:cd=5:or=37:mi=37:ex=32:*.rpm=1;31:*.zip=1;31'
# visuals end

# my edits end
