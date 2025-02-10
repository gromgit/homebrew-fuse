# string formatters
if [[ -t 1 ]]
then
  Tty_escape() { printf "\033[%sm" "$1"; }
else
  Tty_escape() { :; }
fi
Tty_mkbold() { Tty_escape "1;${1:-39}"; }
Tty_red=$(Tty_mkbold 31)
Tty_green=$(Tty_mkbold 32)
Tty_brown=$(Tty_mkbold 33)
Tty_blue=$(Tty_mkbold 34)
Tty_magenta=$(Tty_mkbold 35)
Tty_cyan=$(Tty_mkbold 36)
Tty_white=$(Tty_mkbold 37)
Tty_underscore=$(Tty_escape 38)
Tty_bold=$(Tty_mkbold 39)
Tty_reset=$(Tty_escape 0)

# fatal: Report fatal error
# USAGE: fatal <msg> ...
fatal() {
  echo "${Tty_red}${msg_prefix}FATAL ERROR:${Tty_reset} $*" >&2
  exit 1
}

# error: Report error
# USAGE: error <msg> ...
error() {
  echo "${Tty_red}${msg_prefix}ERROR:${Tty_reset} $*" >&2
}

# warn: Report warning
# USAGE: warn <msg> ...
warn() {
  echo "${Tty_blue}${msg_prefix}Warning:${Tty_reset} $*" >&2
}

# info: Informational message
# USAGE: info <msg> ...
info() {
  echo "${Tty_green}${msg_prefix}Info:${Tty_reset} $*" >&2
}

# need_progs: Checks for command dependencies
# USAGE: need_progs <cmd> ...
need_progs() {
  local missing=()
  local i
  for i in "$@"
  do
    type -P "${i}" &>/dev/null || missing+=("${i}")
  done
  if [[ ${#missing[@]} -gt 0 ]]
  then
    fatal "Commands missing: ${missing[*]}"
    exit 1
  fi
}

# cmd: Show command being run
# USAGE: cmd <cmd> ...
cmd() {
  echo "${Tty_cyan}>>> $*${Tty_reset}" >&2
  command "$@"
}

# git_in: Run Git command in repo
# USAGE: git_in <repo> <cmd> ...
git_in() {
  local repo=$1
  shift
  pushd "${repo}" >/dev/null || fatal "Can't cd to '${repo}'"
  cmd git "$@"
  popd >/dev/null || exit
}
