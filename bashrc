#
# /etc/bash.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[ -r /usr/share/bash-completion/bash_completion   ] && . /usr/share/bash-completion/bash_completion

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls --color=auto -lt'
alias la='ls --color=auto -A'
alias l='ls --color=auto -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

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

#PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\e[1;37m\]'
#PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] '
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

export TIMEFMT=$'\nreal\t%*E\nuser\t%*U\nsys\t%*S'

[[ $- = *i* ]] && source $HOME/bin/liquidprompt/liquidprompt && neofetch -t

alias wal='wal -o /home/amartya/configurations/pywal_sublime.py'

(cat ~/.cache/wal/sequences &)

export PATH=$PATH:/home/amartya/bin/modules/modules/bin:/home/amartya/.local/bin
source /home/amartya/bin/modules/modules/init/bash
module use --append $HOME/modules

module -s load grace/stable
module -s load gaussian/16
module -s load vmd/1.9.3
module -s load julia/1.5.1
module -s load i-pi/2
module -s load lammps/stable
module -s load plumed/git
