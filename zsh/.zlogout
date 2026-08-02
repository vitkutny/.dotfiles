command_history="$(fc -lI 0 2>/dev/null | cut -d' ' -f4)"

if which task > /dev/null && printf '%s' "$command_history" | grep -Fx -q \
	-e 't' \
	-e 'task' \
	-e 'tt' \
	-e 'taskwarrior-tui' \
	-e 'to' \
	-e 'taskopen' \
; then
	task sync
fi
