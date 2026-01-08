# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# Added by Toolbox App
export PATH="$PATH:/Users/vitkutny/Library/Application Support/JetBrains/Toolbox/scripts"

# https://docs.brew.sh/Manpage#shellenv-shell-
eval "$(/opt/homebrew/bin/brew shellenv)"

# https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key
export GPG_TTY=$(tty)

export EDITOR=vim
export VISUAL=vim
# setting EDITOR to vim also change default zsh bindkey to "bindkey -v" – restore zsh default
bindkey -e

