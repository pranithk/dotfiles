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

PROMPT_COMMAND=prompt_with_git

function prompt_with_git {
        local EXITSTATUS=$?
        branch=$(parse_git_branch)
        modified=$(git diff 2>/dev/null| wc -l)
        if [ $modified != 0 ];
        then
                branch=$BRed$branch
        else
                branch=$BGreen$branch
        fi

        if [[ $UID == "0" ]]; then
                user=$BRed$User
        else
                user=$BGreen$User
        fi
        if [ ${EXITSTATUS} -eq 0 ]
        then
                PS1="$NewLine$user@$Host - $BBlue$PathShort ${branch}$NewLine$Cyan$Time24h ${BGreen}:) ⚡ $Color_Off"
        else
                PS1="$NewLine$user@$Host - $BBlue$PathShort ${branch}$NewLine$Cyan$Time24h ${BRed}:( ⚡ $Color_Off"
        fi
}

export EF_ALIGNMENT=0
ulimit -c unlimited
shopt -s histappend
# Fix 'cd folder' mistakes automatically
shopt -s cdspell
export PYTHONPATH=/usr/local/lib/python2.7/site-packages:$PYTHONPATH
export GOPATH=$HOME/go
export PATH=$PATH:~/.scripts:$GOPATH/bin
export PATH=$PATH:$HOME/.jenv/bin

# added by Miniconda3 installer
export PATH="/home/pk/miniconda3/bin:$PATH"
#eval "$(jenv init -)"
export EDITOR=nvim
