sc_cli_main_() {
  typeset -A cmds=(
    f cmd_fetch_    fetch      cmd_fetch_
    F cmd_filter_   filter     cmd_filter_
    s cmd_sort_     sort       cmd_sort_
    d cmd_describe_ describe   cmd_describe_
    u cmd_users_    users      cmd_users_
                    followings cmd_followings_
                    followers  cmd_followers_
    t cmd_tracks_   tracks     cmd_tracks_
    r cmd_resolve_  resolve    cmd_resolve_
    l cmd_library_  library    cmd_library_
    p cmd_play_     play       cmd_play_
    c cmd_count_    count      cmd_count_
  )

  sc_parse_opts_ $@

  cmd=$cmds[$sc_opt[cmd]]
  [[ -z $cmd ]] && die_ "invalid command $cmd"

  source "$sc_path/src/sc/cmds/${${cmd%%_}##cmd_}.zsh"
  $cmd || die_ "failed to execute $cmd"
}
