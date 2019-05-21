cmd_prune_() {
  case $sc_trailing[1] in
    stale)
      # stale files
      find "$sc_dirs[cache]" -type f -not -mmin $((sc_expiration[cache]/60)) \
        -exec rm '{}' +
      find "$sc_dirs[cache]" -type l -not -mmin $((sc_expiration[resolve]/60)) \
        -exec rm '{}' +
      ;;
    links | broken)
      # invalid links
      find -L "$sc_dirs[base]" -type l -exec rm '{}' +
      ;;
    *) die_ "what to prune?"
  esac
}
