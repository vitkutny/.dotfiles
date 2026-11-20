if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
	TMUX_SESSION_PREFIX="$(basename "$PWD")#"
	# strip invalid characters for tmux session
	#TMUX_SESSION_PREFIX="${TMUX_SESSION_PREFIX//[:.]/_}"
	TMUX_SESSION_PREFIX="${TMUX_SESSION_PREFIX//:/꞉}"
	TMUX_SESSION_PREFIX="${TMUX_SESSION_PREFIX//./․}"
	TMUX_SESSION_ID=1
	while tmux has-session -t "${TMUX_SESSION_PREFIX}${TMUX_SESSION_ID}" 2>/dev/null; do
		((TMUX_SESSION_ID++))
	done
	TMUX_SESSION="${TMUX_SESSION_PREFIX}${TMUX_SESSION_ID}"
	exec tmux new-session -A -s "${TMUX_SESSION}" \
		-e TMUX_SESSION_ROOT=1 \
		\; set status-left-length 0 \
		\; set status-right-length 0 \
		\; set-option destroy-unattached on \
		\; set-hook session-renamed 'set-option -u destroy-unattached' \
	;
	exit 0
fi

if [ -n "$TMUX_SESSION_ROOT" ]; then
	alias tmux='TMUX="" tmux'
fi

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
if [ -f "$HOMEBREW_PREFIX/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh" ]; then
	source "$HOMEBREW_PREFIX/opt/fzf-tab/share/fzf-tab/fzf-tab.zsh"
fi

# https://github.com/junegunn/fzf?tab=readme-ov-file#setting-up-shell-integration
if which fzf > /dev/null; then
	FZF_ALT_C_COMMAND= source <(fzf --zsh)
fi

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

function wrap () {
	local wrap_cols="$1"

	if [ "$wrap_cols" -eq 0 ]; then
		wrap_cols=65535 # max zsh $COLUMNS size
	fi

	local tput_cols="$(tput cols)"
	# stty: stdin isn't a terminal 2>/dev/null
	stty cols $wrap_cols 2>/dev/null
	${*:2}
	stty cols "$tput_cols" 2>/dev/null
}

alias nowrap='wrap 0'

# aliases
if which aws > /dev/null; then
	function aws-profile() {
	  export AWS_PROFILE="$(aws configure list-profiles | fzf)"
	  echo "Switched to profile ""$AWS_PROFILE""."
	}
fi

if which dscacheutil > /dev/null; then
	function dns-flushcache () {
		sudo dscacheutil -flushcache
		sudo killall -HUP mDNSResponder
	}
fi
if which kubectl > /dev/null; then
	alias k='kubectl'
	alias kc='kubectl-ctx'
	alias kn='kubectl-ns'
fi

if which taskwarrior-tui > /dev/null; then
	alias tt='taskwarrior-tui'
fi
if which taskopen > /dev/null; then
	alias to='taskopen'
fi

if which timew > /dev/null; then
	function timew () {
		if [ -t 1 ]; then # stdout to terminal
			command timew $*
		else # output used for processing
			# override getTerminalWidth for consistent summary https://github.com/GothenburgBitFactory/timewarrior/blob/8cda469a52b270ef3593b27180547f8f7d1ec8ad/src/helper.cpp#L518
			nowrap command timew $*
		fi
	}

	alias tw='timew'
	function tw_table () {
		sed '1d;3d' < /dev/stdin | detect columns --guess $*
	}
	function tw_csv () {
		tw_table $* '| to csv'
	}
fi

if which task > /dev/null; then
	alias t='task'
	_task_sync_preexec () {
		local command="$(echo "$2" | cut -d' ' -f1)"
		local command_argument="$(echo "$2" | cut -d' ' -f1 -f2)"

		if printf '%s' "$command" | grep -Fx -q \
			-e 'task' \
			-e 'taskwarrior-tui' \
			-e 'taskopen' \
		; then
			unset -f _task_sync_preexec

			if [ "$command_argument" != "task sync" ]; then
				task sync
			fi
		fi
	}
fi

function clear_storage() {
	tmutil deletelocalsnapshots /
}

fpath=( ~/.config/zsh/functions "${fpath[@]}" )
autoload -Uz $fpath[1]/*(-.:t)

PROMPT='%~ %# '

# Emit OSC 133 semantic prompt sequences
# A: Start of prompt
# B: End of prompt / start of user input (%{...%} prevents Zsh cursor miscalculation)
PROMPT="%{"$'\e]133;A\a'"%}${PROMPT}%{"$'\e]133;B\a'"%}"
_osc133_preexec() {
	_OSC133_CMD_STARTED=1
	# C: Start of command output
	printf '\e]133;C;cmdline_url=%s\a' "$(percent-encode "$1")"
}
_osc133_precmd() {
	local exit_status=$?
	# D: End of previous command + exit status (skip on initial shell startup)
	if [[ -n "$_OSC133_CMD_STARTED" ]]; then
		unset _OSC133_CMD_STARTED
		printf '\e]133;D;%s\a' "$exit_status"
		printhr
	fi
}

_osc2_precmd() {
    printf "\033]2;%s\033\\" "$HOST"
}

autoload -Uz add-zsh-hook
if (( $+functions[_task_sync_preexec] )); then
	add-zsh-hook preexec _task_sync_preexec
fi
add-zsh-hook preexec _osc133_preexec
add-zsh-hook precmd _osc133_precmd
add-zsh-hook precmd _osc2_precmd
