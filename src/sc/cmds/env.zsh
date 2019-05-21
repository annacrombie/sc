cmd_env_() {
  find --version | head -n 1
  git --version
  jq --version
  mktemp --version | head -n 1
  tree --version
  which wcache
  zsh --version
  echo "sc $sc_version"
}
