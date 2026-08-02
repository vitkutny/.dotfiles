# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
if [ -f ~/.orbstack/shell/init.zsh ]; then
	source ~/.orbstack/shell/init.zsh 2>/dev/null || :
fi

# https://docs.brew.sh/Manpage#s hellenv-shell-
if [ -f /opt/homebrew/bin/brew ]; then
	eval "$(/opt/homebrew/bin/brew shellenv zsh)"
elif [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
fi

fpath=(
    ~/.local/share/zsh/site-functions
    $fpath
)

# ~/.local/bin – on last position – overriding of system binaries not allowed
export PATH="$PATH:$HOME/.local/bin"

# https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key
export GPG_TTY=$(tty)

# default commands
export EDITOR=vim
export VISUAL=vim

# kubectl
export KUBECONFIG=$HOME/.kube/config

if [ -d ~/.kube/config.d ]; then
	for i in $(ls ~/.kube/config.d/*);
	    do export KUBECONFIG=$KUBECONFIG:$i
	done
fi
