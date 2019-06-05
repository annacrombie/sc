jq -Mr '.username' \
  "test/data/offline/cache/api.soundcloud.com/users/100787952\$" >/dev/null && \
  echo -e "column|output|is\nworking|!|!" | column -s '|' -t >/dev/null && \
  tmp=$(mktemp) && \
  [[ -f "$tmp" ]] && rm "$tmp"
