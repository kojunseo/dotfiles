# Open Markdown files and directories with Leaf.
function md() {
  if ! command -v leaf >/dev/null 2>&1; then
    print -u2 -- "md: leaf is not installed."
    return 127
  fi

  command leaf "$@"
}

if (( $+functions[compdef] )); then
  compdef _files md
fi
