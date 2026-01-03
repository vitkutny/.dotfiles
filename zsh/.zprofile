alias aws='docker run --rm -ti -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli'


# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :


# Added by Toolbox App
export PATH="$PATH:/Users/vitkutny/Library/Application Support/JetBrains/Toolbox/scripts"

eval "$(/opt/homebrew/bin/brew shellenv)"
export GPG_TTY=$(tty)

autoload -Uz compinit
compinit

