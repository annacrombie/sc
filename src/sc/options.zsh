sc_parse_opts_() {
  typeset -gA opts=(
    take=         "set the limit on results"
    verbose       "enable verbose output"
    version       "show the version"
    force         "always download new files"
    cache=        "set the cache dir"
    config=       "set the configuration file"
    force-tty-out "force sc to think it is outputting to a tty"
    force-tty-in  "force sc to think it is reading from a tty"
  )
  typeset -gA optalias=(
    t take=
    V verbose
    v version
    f force
    c cache=
    C config=
  )

  optparse_parse_ opts optalias $@

  typeset -gA sc_opt=(${(kv)optparse_result})
  log_debug_ "parsed options: ${(kv)sc_opt}"

  [[ $sc_opt[force-tty-out] ]] && sc_tty=true
  [[ $sc_opt[force-tty-in] ]] && unset sc_pipe

  if [[ $sc_opt[version] ]]; then
    echo "sc version $sc_version"
    exit
  fi

  typeset -ga sc_exec=($sc_exec)

  if [[ $sc_opt[cache] ]]; then
    sc_dirs[base]="$sc_opt[cache]"
    sc_dirs[cache]="$sc_dirs[base]/cache"
    sc_dirs[api]="$sc_dirs[base]/cache/$sc_api_base"
    sc_dirs[tracks]="$sc_dirs[base]/tracks"
    sc_exec+="--cache=$sc_opt[cache]"
  fi

  if [[ $sc_opt[config] ]]; then
    log_debug_ "setting config file to $sc_opt[config]"
    sc_cfg_file="$sc_opt[config]"
    sc_exec+="--config=$sc_opt[config]"
  fi

  [[ $sc_opt[take] ]] && sc_exec+="--take=$sc_opt[take]"
  sc_opt[take]=${sc_opt[take]:-"x"}

  if [[ $sc_opt[verbose] ]]; then
    typeset -g sc_verbosity=2
    sc_exec+="--verbose"
  fi

  sc_opt[cmd]=$optparse_trailing[1]
  typeset -ga sc_trailing=(${optparse_trailing[2,-1]})

  unset opts optalias optparse_result optparse_trailing
  log_debug_ "new sc_exec: $sc_exec"
}
