typeset -g config="test/cfg/online.zsh"
typeset -g cache="test/data/online"
typeset user="sc-api-test"

[[ -d "$cache" ]] && rm -r "$cache"/*

typeset -ga tests=(
  "mu r sc-api-test | jq -Mr '.username'"
  =
  "test-account"

  "mu r sc-api-test | mu t | mu c"
  =
  1

  "mu r sc-api-test | mu -t 1 t | jq -Mr '.title'"
  =
  track
)

wget -q --tries=1 --timeout=20 --spider https://soundcloud.com

if [[ $? -ne 0 ]]; then
  echo "\e[33munable to access soundcloud api\e[0m"
  tests=()
fi
