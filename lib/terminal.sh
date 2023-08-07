terminal_width=$(tput cols)

## Print message in the format: $prefix === $suffix
# Parameters:
#  - $1: prefix (optional)
#  - $2: suffix (optional)
function message() {
	prefix="$1"
	suffix="$2"
	line_length=$((terminal_width - ${#prefix} - ${#suffix} - 2))
	spacer=$(printf "%${line_length}s" | tr ' ' '=')
	pattern="%s %s %s"
	if [[ -z "$prefix" && -z "$suffix" ]]; then
		pattern="%s=%s=%s"
	elif [[ -z "$prefix" ]]; then
		pattern="%s%s= %s"
	elif [[ -z "$suffix" ]]; then
		pattern="%s =%s%s"
	fi
	# shellcheck disable=SC2059
	printf "${pattern}\n" "$prefix" "$spacer" "$suffix"
}

function spin() {
	for s in / - \\ \|; do
		printf "%s" "$s"
		tput cub 1
		sleep .05
	done
}

function clear_line() {
	tput cr # move to the beggining of the current line
	tput el # clear until end of line
}

function clear_previous_line() {
	tput cuu1
	tput cr # move to the beggining of the current line
	tput el # clear until end of line
}

function async_run() {
	local output_file=$1
	local work_function=$2

	(
		$work_function &>"$output_file"
		exit $?
	) &
	pid=$!

	clear_line
	until [[ -z $(pgrep -P $$) ]]; do
		spin
	done
	clear_line

	wait $pid
	exit_status=$?

	return $exit_status
}
