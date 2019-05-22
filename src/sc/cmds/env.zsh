cmd_env_() {
  echo "package versions\n"
  find --version | head -n 1
  jq --version
  mktemp --version | head -n 1
  ln --version | head -n 1
  tree --version
  zsh --version
  column --version
  echo "optparse master@$(cat "$sc_path"/deps/optparse/.git/refs/heads/master)"
  echo "wcache master@$(cat "$sc_path"/deps/wcache/.git/refs/heads/master)"
  echo "sc $sc_version master@$(cat "$sc_path"/.git/refs/heads/master)"

  echo "\nsc state\n"

  [[ -n "$sc_key" ]] && sc_key=${sc_key//[[:alnum:]]/x}

  typeset -m 'sc_*' | sort
  typeset -m PWD
}
