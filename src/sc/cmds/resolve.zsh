#resolve soundcloud permalink
cmd_resolve_() {
  resolve_ $sc_trailing
  typeset -a resolved=(${(s: :)returned})
  output_ "$sc_dirs[api]/${(j:/:)resolved}" ${resolved[1]%%s}
}
