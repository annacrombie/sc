cmd_filter_() {
  cat -
  # [[ $#sc_trailing != 3 ]] && die_ "filter must consist of 3 parts"
  # typeset -ga sc_filter=(${sc_trailing[1,3]})

  # if [[ $sc_pipe ]]; then
  #   while read -r line; do
  #     eval "typeset -A data=(${line})"
  #     filter_accept_ ${(kv)data} && echo "$line"
  #   done
  # else
  #   die_ "no input"
  # fi
}
