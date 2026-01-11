# https://github.com/sindresorhus/pure
autoload -U promptinit; promptinit
prompt pure > /dev/null

if [ "$(prompt -c | tr -d "\n" | tr -s ' ')" = "Current prompt theme is: pure" ]; then
	zstyle :prompt:pure:path color default
	zstyle ':prompt:pure:prompt:*' color default
	#zstyle :prompt:pure:prompt:error color red
	#zstyle :prompt:pure:prompt:success color green

	# https://github.com/sindresorhus/pure/wiki/Customizations,-hacks-and-tweaks#disable-pure-terminal-title-updates
	prompt_pure_set_title() {}

	# https://github.com/sindresorhus/pure/wiki/Customizations,-hacks-and-tweaks#show-exit-code-of-all-piped-commands-in-rprompt
	# https://github.com/sindresorhus/pure/wiki/Customizations,-hacks-and-tweaks#show-system-time-in-prompt
	prompt_pipestatus='0'
	prompt_pipestatus_color=green
	precmd_prompt_pipestatus() {
		local exitcodes=(${pipestatus[@]})
		prompt_pipestatus="${(j.|.)exitcodes}"
		prompt_pipestatus_color=green

		for exitcode in ${exitcodes[@]}; do
			if ! [[ $exitcode -eq 0 ]]; then
				prompt_pipestatus_color=red
			fi
		done
	}
	add-zsh-hook precmd precmd_prompt_pipestatus
	PROMPT='%F{$prompt_pipestatus_color}[$prompt_pipestatus]%f %F{$prompt_pure_colors[execution_time]}%*%f $prompt_newline'$PROMPT
fi

# https://coderwall.com/p/jpj_6q/zsh-better-history-searching-with-arrow-keys
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

# https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/key-bindings.zsh
# Edit the current command line in $VISUAL (or $EDITOR / `vi` if not set)
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# before compinit
fpath=(
    ~/.local/share/zsh/site-functions
    $fpath
)
# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
autoload -Uz compinit
compinit

# https://github.com/Aloxaf/fzf-tab?tab=readme-ov-file#manual
source ~/.dotfiles/zsh/submodules/fzf-tab/fzf-tab.plugin.zsh

# https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration
FZF_ALT_C_COMMAND= source <(fzf --zsh)

# aliases
alias aws='docker run --rm -ti -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli'
alias t='task'
alias tt='taskwarrior-tui'
alias tw='timew'

