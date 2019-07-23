#remove files from the cache
prune_stale_() {
  if [[ $mu_expiration[cache] != inf ]]; then
    find "$mu_dirs[cache]" -type f -not -name 'stream$' \
      -not -mmin -$((mu_expiration[cache]/60)) \
      -exec rm -v '{}' +
  fi

  if [[ $mu_expiration[resolve] != inf ]]; then
    find "$mu_dirs[cache]" -type l \
      -not -mmin -$((mu_expiration[resolve]/60)) \
      -exec rm -v '{}' +
  fi

  if [[ $mu_expiration[tracks] != inf ]]; then
    find "$mu_dirs[cache]" -type f \
      -name 'stream$' \
      -not -mmin -$((mu_expiration[tracks]/60)) \
      -exec rm -v '{}' +
  fi
}

prune_links_() {
  find -L "$mu_dirs[base]" -type l -exec rm -v '{}' +
}

prune_empty_() {
  find data -empty -exec rm -rv '{}' +
}

cmd_prune_() {
  case $mu_trailing[1] in
    stale) prune_stale_;;
    links | broken) prune_links_;;
    empty) prune_empty_;;
    all) prune_stale_; prune_links_; prune_empty_;;
    *) die_ "what to prune?"
  esac
}
