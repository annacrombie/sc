#remove files from the cache
prune_stale_() {
  if [[ $sc_expiration[cache] != inf ]]; then
    find "$sc_dirs[cache]" -type f -not -name 'stream$' \
      -not -mmin -$((sc_expiration[cache]/60)) \
      -exec rm -v '{}' +
  fi

  if [[ $sc_expiration[resolve] != inf ]]; then
    find "$sc_dirs[cache]" -type l \
      -not -mmin -$((sc_expiration[resolve]/60)) \
      -exec rm -v '{}' +
  fi

  if [[ $sc_expiration[tracks] != inf ]]; then
    find "$sc_dirs[cache]" -type f \
      -name 'stream$' \
      -not -mmin -$((sc_expiration[tracks]/60)) \
      -exec rm -v '{}' +
  fi
}

prune_links_() {
  find -L "$sc_dirs[base]" -type l -exec rm -v '{}' +
}

prune_empty_() {
  find data -empty -exec rm -rv '{}' +
}

cmd_prune_() {
  case $sc_trailing[1] in
    stale) prune_stale_;;
    links | broken) prune_links_;;
    empty) prune_empty_;;
    all) prune_stale_; prune_links_; prune_empty_;;
    *) die_ "what to prune?"
  esac
}
