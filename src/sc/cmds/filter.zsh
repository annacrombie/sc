#filter input using jq
cmd_filter_() {
  typeset filter=${sc_trailing[1]}
  mktmp_
  typeset tmp="$returned"

  jq_ slurp s "[.[] | select($filter)]" - > $tmp

  output_ "$tmp" mix
}
