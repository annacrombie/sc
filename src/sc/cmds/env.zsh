cmd_env_() {
  echo "package versions\n"
  find --version | head -n 1
  jq --version
  mktemp --version | head -n 1
  ln --version | head -n 1
  tree --version
  which wcache
  zsh --version
  echo "sc $sc_version master@$(cat $sc_path/.git/refs/heads/master)"

  echo "\nsc state\n"

  unset sc_key # don't output secret key
  typeset -m 'sc_*' | sort
  typeset -m PWD
}
