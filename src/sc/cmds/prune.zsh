cmd_prune_() {
  case $sc_trailing[1] in
    stale)
      # stale files
      find "$sc_dirs[cache]" -type f -not -mmin 60 -exec rm '{}' +
      ;;
    links)
      # invalid links
      find -L sc_data -type l
      ;;
    *) die_ "what to prune?"
  esac
}
