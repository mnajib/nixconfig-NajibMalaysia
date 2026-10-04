#!/usr/bin/env bash
# blocky-hl — highlight the queried domain in Blocky query logs
#
# Usage:
#   blocky-hl                follow Blocky live (journalctl -u blocky -f)
#   blocky-hl -n 500         start from the last 500 lines, then follow
#   blocky-hl -a             also show non-query lines (default: queries only)
#   blocky-hl -g REGEX       only queries whose domain matches REGEX (ERE)
#   blocky-hl -s [-n LINES]  summary: top-domain bar chart + kesimpulan (no follow)
#   blocky-hl -h             show help
#   some-cmd | blocky-hl     read stdin instead of journalctl
#
# Examples:
#   blocky-hl -g 'whatsapp|fbcdn'     watch only WhatsApp-related domains
#   blocky-hl -s -n 5000              summary of the last 5000 log lines
#
# Layout (Haskell-style):
#   pure_*  = stdin -> stdout stages, no side effects, composed with pipes
#   io_*    = functions that touch the outside world (journalctl, printing)
#
# If journalctl prints nothing, your user may not be allowed to read the
# system journal: try again with sudo.
# Piping into `less` needs: less -R  (to keep the colors)

# ---------- constants ----------------------------------------------------

readonly ESC=$'\033'
readonly RESET="${ESC}[0m"
readonly C_DOMAIN="${ESC}[1;93m"   # bold bright yellow
readonly C_BLOCKED="${ESC}[31m"    # red
readonly C_CACHED="${ESC}[36m"     # cyan
readonly C_RESOLVED="${ESC}[32m"   # green
readonly C_CONDITIONAL="${ESC}[35m" # magenta (forwarded to BIND)

usage() {
  cat <<'EOF'
Usage: blocky-hl [-n LINES] [-a] [-g REGEX] [-s] [-h]
  -n LINES  how many past log lines to start from (default 200)
  -a        show all lines, not only queryLog lines
  -g REGEX  only queries whose domain matches REGEX (extended regex)
  -s        summary mode (bar chart + kesimpulan), no live follow
  -h        this help
EOF
}

# ---------- pure stages: stdin -> stdout ---------------------------------

pure_keep_queries() { grep --line-buffered 'queryLog:' || true; }

# pure_filter_domain REGEX : keep lines whose question_name matches REGEX
# (an empty REGEX means no filtering: every line passes through)
pure_filter_domain() {
  if [ -z "$1" ]; then
    cat
  else
    grep --line-buffered -E "question_name=[^ ]*(${1})" || true
  fi
}

# pure_select ALL REGEX : ALL=1 keeps every line, otherwise only queryLog lines;
# then the optional domain filter is applied.
# (No "stage=cat" variable: shellcheck SC2209 rejects assigning a command name.)
pure_select() {
  if [ "$1" -eq 1 ]; then
    cat
  else
    pure_keep_queries
  fi | pure_filter_domain "$2"
}

pure_hl_type() {
  sed -u -E \
    -e "s/(response_type=BLOCKED)/${C_BLOCKED}\1${RESET}/" \
    -e "s/(response_type=CACHED)/${C_CACHED}\1${RESET}/" \
    -e "s/(response_type=RESOLVED)/${C_RESOLVED}\1${RESET}/" \
    -e "s/(response_type=CONDITIONAL)/${C_CONDITIONAL}\1${RESET}/"
}

pure_hl_domain() {
  sed -u -E "s/(question_name=)([^ ]+)/\1${C_DOMAIN}\2${RESET}/"
}

pure_highlight() { pure_hl_type | pure_hl_domain; }

# ---------- pure helpers for summary mode --------------------------------

pure_domains() { grep -oE 'question_name=[^ ]+' | cut -d= -f2- || true; }
pure_types()   { grep -oE 'response_type=[A-Z]+' | cut -d= -f2 || true; }

# pure_top N : "count value" lines, biggest first, at most N
# (sed instead of head: head can close the pipe early and trip pipefail)
pure_top() { sort | uniq -c | sort -rn | sed -n "1,${1}p"; }

# pure_bars : "count value" lines -> "value  count  ████"
pure_bars() {
  awk -v w=30 '
    { n[NR] = $1; d[NR] = $2; if ($1 > m) m = $1 }
    END {
      for (i = 1; i <= NR; i++) {
        len = int(n[i] * w / m); bar = ""
        for (j = 0; j < len; j++) bar = bar "█"
        printf "%-34s %5d %s\n", d[i], n[i], bar
      }
    }'
}

# pure_percent PART TOTAL : integer percentage, 0 when TOTAL is 0
pure_percent() {
  if [ "$2" -eq 0 ]; then echo 0; else echo $(( 100 * $1 / $2 )); fi
}

# ---------- io functions -------------------------------------------------

# io_input MODE LINES : stdin if piped, else journalctl (MODE = follow|snapshot)
io_input() {
  if [ ! -t 0 ]; then
    cat
  elif [ "$1" = follow ]; then
    journalctl -u blocky -n "$2" -f -o cat
  else
    journalctl -u blocky -n "$2" --no-pager -o cat
  fi
}

# io_summary LINES : bar charts + kesimpulan
io_summary() {
  local n=$1 data total blocked cached top
  data=$(io_input snapshot "$n" | pure_keep_queries)

  total=$(printf '%s\n' "$data" | grep -c 'queryLog:' || true)
  blocked=$(printf '%s\n' "$data" | grep -c 'response_type=BLOCKED' || true)
  cached=$(printf '%s\n' "$data" | grep -c 'response_type=CACHED' || true)
  top=$(printf '%s\n' "$data" | pure_domains | pure_top 1 | awk '{print $2}')

  echo "== Top 10 domains (last ${n} log lines) =="
  printf '%s\n' "$data" | pure_domains | pure_top 10 | pure_bars
  echo
  echo "== Response types =="
  printf '%s\n' "$data" | pure_types | pure_top 10 | pure_bars
  echo
  echo "== Kesimpulan =="
  echo "Total queries  : ${total}  (A and AAAA are counted separately)"
  echo "Blocked        : ${blocked} ($(pure_percent "$blocked" "$total")%)"
  echo "Served by cache: ${cached} ($(pure_percent "$cached" "$total")%)"
  echo "Busiest domain : ${top:-n/a}"
}

main() {
  local lines=200 all=0 regex="" summary=0 opt
  while getopts "n:ag:sh" opt; do
    case "$opt" in
      n) lines=$OPTARG ;;
      a) all=1 ;;
      g) regex=$OPTARG ;;
      s) summary=1 ;;
      h) usage; exit 0 ;;
      *) usage; exit 1 ;;
    esac
  done

  if [ "$summary" -eq 1 ]; then
    io_summary "$lines"
  else
    io_input follow "$lines" | pure_select "$all" "$regex" | pure_highlight
  fi
}

main "$@"
