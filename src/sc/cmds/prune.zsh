cmd_prune_() {
  case $sc_trailing[1] in
    stale)
      # stale files
      if [[ $sc_expiration[cache] != inf ]]; then
        find "$sc_dirs[cache]" -type f -not -name 'stream$' \
          -not -mmin $((sc_expiration[cache]/60)) \
          -exec rm -v '{}' +
      fi

      if [[ $sc_expiration[resolve] != inf ]]; then
        find "$sc_dirs[cache]" -type l \
          -not -mmin $((sc_expiration[resolve]/60)) \
          -exec rm -v '{}' +
      fi

      if [[ $sc_expiration[tracks] != inf ]]; then
        find "$sc_dirs[cache]" -type f \
          -name 'stream$' \
          -not -mmin $((sc_expiration[tracks]/60)) \
          -exec rm -v '{}' +
      fi
      ;;
    links | broken)
      # invalid links
      find -L "$sc_dirs[base]" -type l -exec rm -v '{}' +
      ;;
    *) die_ "what to prune?"
  esac
}
