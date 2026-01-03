# https://github.com/sindresorhus/pure
zstyle :prompt:pure:path color blue
zstyle :prompt:pure:git:branch color default
zstyle ':prompt:pure:prompt:*' color blue
#zstyle :prompt:pure:prompt:error color red
#zstyle :prompt:pure:prompt:success color green
autoload -U promptinit; promptinit
prompt pure
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


# https://coderwall.com/p/jpj_6q/zsh-better-history-searching-with-arrow-keys
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

