cmd_prune_() {
  case $sc_trailing[1] in
    stale)
      # stale files
      find "$sc_dirs[cache]" -type f -not -mmin $((sc_expiration[cache]/60)) \
        -exec echo '{}' +
      find "$sc_dirs[cache]" -type l -not -mmin $((sc_expiration[resolve]/60)) \
        -exec echo '{}' +
      ;;
    links | broken)
      # invalid links
      find -L "$sc_dirs[base]" -type l -exec echo '{}' +
      ;;
    *) die_ "what to prune?"
  esac
}
