# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Source bash aliases
if [ -f ~/.bash_alias ]; then
        . ~/.bash_alias
fi

if [ -f ~/.bash_dirs ]; then
        . ~/.bash_dirs
fi

if [ -f /usr/share/doc/git-1.7.7.6/contrib/completion/git-completion.bash ]; then
        source /usr/share/doc/git-1.7.7.6/contrib/completion/git-completion.bash
fi

# User specific aliases and functions
function parse_git_branch {
            git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

function exitstatus {

    EXITSTATUS="$?"

    if [ "${EXITSTATUS}" -eq 0 ]
    then
            PS1="\n\[\033[01;34m\]\u @ $(hostname) \w\n\[\033[0;36m\]\t \[\e[32;1m\]:) ⚡ \[\033[0;39m\]"
    else
            PS1="\n\[\033[01;34m\]\u @ $(hostname) \w\n\[\033[0;36m\]\t \[\033[1;31m\]:( ⚡ \[\033[0;39m\]"
    fi
}

function prompt_with_git {
        EXITSTATUS="$?"
        branch=$(parse_git_branch)
        modified=$(git diff 2>/dev/null| wc -l)
        if [ $modified != 0 ];
        then
                branch=$BRed$branch
        else
                branch=$BGreen$branch
        fi

        if [ "${EXITSTATUS}" -eq 0 ]
        then
                PS1="$NewLine$BRed$User @ $BBlue$PathShort ${branch}$NewLine$Cyan$Time24h ${BGreen}:) ⚡ $Color_Off"
        else
                PS1="$NewLine$BRed$User @ $BBlue$PathShort ${branch}$NewLine$Cyan$Time24h ${BRed}:( ⚡ $Color_Off"
        fi
}

PROMPT_COMMAND=prompt_with_git

export EF_ALIGNMENT=0
export PATH=$PATH:~/.scripts
export GOROOT=$HOME/go
export PATH=$PATH:$GOROOT/bin
ulimit -c unlimited
shopt -s histappend
