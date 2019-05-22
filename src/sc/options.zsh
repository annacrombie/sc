sc_parse_opts_() {
  typeset -gA opts=(
    take=    "set the limit on results"
    verbose  "enable verbose output"
    version  "show the version"
    force    "always download new files"
    cache=   "set the cache dir"
  )
  typeset -gA optalias=(t take= V verbose v version f force c cache=)

  optparse_parse_ opts optalias $@

  typeset -gA sc_opt=(${(kv)optparse_result})

  if [[ $sc_opt[version] ]]; then
    echo "sc version $sc_version"
    exit
  fi

  if [[ $sc_opt[cache] ]]; then
    sc_dirs[base]="$sc_opt[cache]"
    sc_dirs[cache]="$sc_dirs[base]/data/cache"
    sc_dirs[api]="$sc_dirs[base]/data/cache/$sc_api_base"
    sc_dirs[tracks]="$sc_dirs[base]/data/tracks"
  fi

  typeset -ga sc_exec=($sc_exec)
  [[ $sc_opt[take] ]] && sc_exec+="--take=$sc_opt[take]"
  sc_opt[take]=${sc_opt[take]:-"x"}

  if [[ $sc_opt[verbose] ]]; then
    typeset -g sc_verbosity=2
    sc_exec+="--verbose"
  fi

  sc_opt[cmd]=$optparse_trailing[1]
  typeset -ga sc_trailing=(${optparse_trailing[2,-1]})

  unset opts optalias optparse_result optparse_trailing
}
