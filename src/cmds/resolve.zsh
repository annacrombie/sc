#resolve soundcloud permalink
cmd_resolve_() {
  resolve_ $mu_trailing
  typeset -a resolved=(${(s: :)returned})
  output_ "$mu_dirs[api]/${(j:/:)resolved}" ${resolved[1]%%s}
}
