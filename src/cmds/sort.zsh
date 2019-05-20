cmd_sort_() {
  typeset -A sort_keys
  typeset sort_col
  typeset tmp=$(mktemp)

  cat - > $tmp

  line="$(head -n 1 "$tmp")"
  eval "typeset -A data=(${line})"
  case $data[type] in
    user) sort_keys=(type 2 id 4 followers 6 username 8 last_modified 10);;
    track) sort_keys=(type 2 id 4 plays 8 last_modified 10 dl 12 artist 14 title 16);;
  esac

  sort_col=$sort_keys[$sc_trailing[1]]

  [[ -z $sort_col ]] && \
    die_ "invalid sort column $sc_trailing[1] for $data[type]"

  echo sort ${sc_trailing[2,-1]} --key=$sort_col "$tmp"
  sort ${sc_trailing[2,-1]} --key=$sort_col "$tmp" |
    if [[ $optparse_result[take] ]]; then
      head -n $optparse_result[take]
    else
      cat -
    fi

  rm "$tmp"
}
