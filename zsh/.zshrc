eval "$(oh-my-posh init zsh  --config ~/.config/oh-my-posh/config.toml)"
function set_poshcontext() {
	export POSH_TASK_PROMPT="$(task rc.context=none rc.verbose=off rc._forcecolor=on prompt 2>/dev/null | xargs)"
}

# setting EDITOR to vim also change default zsh bindkey to "bindkey -v" – restore zsh default
bindkey -e

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

# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
autoload -Uz compinit
compinit

# https://github.com/Aloxaf/fzf-tab?tab=readme-ov-file#manual
source ~/.dotfiles/zsh/submodules/fzf-tab/fzf-tab.plugin.zsh

# https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration
FZF_ALT_C_COMMAND= source <(fzf --zsh)

# https://www.nushell.sh/commands/docs/detect.html
function detect () {
	nu -c "cat - | detect $*" </dev/stdin
}
# https://www.nushell.sh/commands/docs/from.html
function from () {
	nu -c "cat - | from $*" </dev/stdin
}
function from_table () {
	# convert string table to TSV – remove "|" below header and around table from all sides, remaining "|" replaced with \t
	# tsv converted to table inside nu, rejected # column and converted to desired format
	sed -e '1d;3d;$d' -e 's/^.//' -e 's/.$//' < /dev/stdin | tr '│' '\t' | nu -c "cat - | from tsv --trim all | reject '#' $*"
}

function nowrap () {
	local tput_cols="$(tput cols)"
	# stty: stdin isn't a terminal 2>/dev/null
	stty cols 65535 2>/dev/null # max zsh $COLUMNS size
	$*
	stty cols "$tput_cols" 2>/dev/null
}

function timew () {
	if [ -t 1 ]; then # stdout to terminal
		command timew $*
	else # output used for processing
		# override getTerminalWidth for consistent summary https://github.com/GothenburgBitFactory/timewarrior/blob/8cda469a52b270ef3593b27180547f8f7d1ec8ad/src/helper.cpp#L518
		nowrap command timew $*
	fi
}

# aliases
alias aws='docker run --rm -ti -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli'
alias t='task'
alias tt='taskwarrior-tui'
alias tw='timew'
function tw_table () {
	sed '1d;3d' < /dev/stdin | detect columns --guess $*
}
function tw_csv () {
	tw_table $* '| to csv'
}

preexec_task_sync () {
	local command="$(echo "$2" | cut -d' ' -f1)"
	local command_argument="$(echo "$2" | cut -d' ' -f1 -f2)"

	if printf '%s' "$command" | grep -Fx -q \
		-e 'task' \
		-e 'taskwarrior-tui' \
		-e 'taskopen' \
	; then
		unset -f preexec_task_sync

		if [ "$command_argument" != "task sync" ]; then
			task sync
		fi
	fi
}
add-zsh-hook preexec preexec_task_sync
