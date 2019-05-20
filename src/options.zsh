sc_parse_opts_() {
  typeset -gA opts=(
    take=    "set the limit on results"
    detailed "produce more detailed info"
  )
  typeset -gA optalias=(t take= d detailed)

  optparse_parse_ opts optalias $@

  typeset -gA sc_opt=(${(kv)optparse_result})

  [[ $sc_opt[take] ]] && typeset -ga sc_exec=($sc_exec --take=$sc_opt[take])
  sc_opt[take]=${sc_opt[take]:-"x"}

  sc_opt[cmd]=$optparse_trailing[1]
  typeset -ga sc_trailing=(${optparse_trailing[2,-1]})

  unset opts optalias optparse_result optparse_trailing
}
