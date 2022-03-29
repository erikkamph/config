function wttr() {
	[ ! -z "$location" ] && return
	[ ! -z "$arg" ] && return
	[ ! -z "$short" ] && return
	[ ! -z "$url_to_curl" ] && return

	wttr_usage() { echo "wttr [-h] [-w] [-l location] [-s]" 1>&2; return }

	local OPTIND o location short url_to_curl
	while getopts ":hwl:s" o; do
		case "${o}" in
			h)
				wttr_usage
				return
				;;
			l)
				location="${OPTARG}"
				;;
			s)
				short=1
				;;
			w)
				curl https://wttr.in/:help
				return
				;;
		esac
	done
	shift $((OPTIND - 1))
	
	url_to_curl="$(python -c "from urllib import parse;query = '$(echo $location)';print(parse.quote(query))")"
	[[ "$short" == 1 ]] && url_to_curl="$url_to_curl?0"
	url_to_curl="https://wttr.in/$url_to_curl"
	curl "$url_to_curl"
}

preexec() {
	if [[ $1 == <-> ]]; then
		if [[ "$1" =~ [0-9]{4,5} ]]; then
			$1() {
				echo "Listening on port $0..."
				nc -lvnp "$0"
				unfunction $0
			}
		fi
	fi
}

[[ "$TERM" == "dumb" ]] && {
	unsetopt zle prompt_cr prompt_subst
	unfunction precmd
	unfunction preexec
	PS1='$ '
}

function tmuxcust() {
	tmux new-session 'gtop' \; splitw -v '/sbin/zsh'
	tmux set-option -g status-style bg=black
	tmux set-option -g status-style fg=gray
}

function space() {
	[[ -z "$1" ]] && return
	echo ''
	$@
	echo ''
}

function ws_icon() {
	[ ! -z "$counter" ] && return
	local counter
	counter=0

	i3-msg -t get_workspaces | tr "," "\n" | sed -nr 's/"name":"([^"]+)"/\1/p' | while read -r name; do
		printf 'ws-icon-%i = "%s;<insert-icon-here>"\n' $((counter++)) $name
	done
}
