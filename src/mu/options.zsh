mu_parse_opts_() {
  typeset -gA opts=(
    take=         "set the limit on results"
    verbose       "enable verbose output"
    version       "show the version"
    force         "always download new files"
    cache=        "set the cache dir"
    config=       "set the configuration file"
    force-tty-out "force mu to think it is outputting to a tty"
    force-tty-in  "force mu to think it is reading from a tty"
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

  [[ ${optparse_result[verbose]} ]] && set_verbosity_ 1

  typeset -gA mu_opt=(${(kv)optparse_result})
  log_debug_ "parsed options: ${(kv)mu_opt}"

  [[ $mu_opt[force-tty-out] ]] && mu_tty=true
  [[ $mu_opt[force-tty-in] ]] && unset mu_pipe

  if [[ $mu_opt[version] ]]; then
    echo "mu version $mu_version"
    exit
  fi

  typeset -ga mu_exec=($mu_exec)

  if [[ $mu_opt[cache] ]]; then
    mu_dirs[base]="$mu_opt[cache]"
    mu_dirs[cache]="$mu_dirs[base]/cache"
    mu_dirs[api]="$mu_dirs[base]/cache/$mu_api_base"
    mu_dirs[tracks]="$mu_dirs[base]/tracks"
    mu_exec+="--cache=$mu_opt[cache]"
  fi

  if [[ $mu_opt[config] ]]; then
    log_debug_ "setting config file to $mu_opt[config]"
    mu_cfg_file="$mu_opt[config]"
    mu_exec+="--config=$mu_opt[config]"
  fi

  [[ $mu_opt[take] ]] && mu_exec+="--take=$mu_opt[take]"
  mu_opt[take]=${mu_opt[take]:-"x"}

  if [[ $mu_opt[verbose] ]]; then
    typeset -g mu_verbosity=2
    mu_exec+="--verbose"
  fi

  mu_opt[cmd]=$optparse_trailing[1]
  typeset -ga mu_trailing=(${optparse_trailing[2,-1]})

  unset opts optalias optparse_result optparse_trailing
  log_debug_ "new mu_exec: $mu_exec"
}
