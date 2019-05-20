cmd_followers_() {
  if [[ $sc_pipe ]]; then
    while read -r line; do
      eval "typeset -A data=(${line})"
      case $data[type] in
        user)
          get_ "users/$data[id]/$sc_resource"
          extract_collection_ $sc_return
          split_ 'users' $sc_return
          if [[ $optparse_result[detailed] ]]; then
            output_ $sc_return 'desc/users'
          else
            output_ $sc_return 'users'
          fi
          ;;
      esac
    done
  else
    $sc_exec resolve $sc_trailing | sc users | sc $sc_resource
  fi
}
