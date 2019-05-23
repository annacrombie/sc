optparse_disp[banner]="sc version $sc_version
Usage: sc [OPTIONS] COMMAND [OPTIONS]"
optparse_disp[desc]="A lightweight soundcloud client, conforming to unix philosophy."

typeset cmd tmp
typeset -a cmdstr=("COMMANDS:")
for cmd in "$sc_path/src/sc/cmds/"*.zsh; do
  typeset cmdname="${${cmd:t}%%.zsh}"
  typeset desc="$(head -n 1 "$cmd")"
  printf -v tmp "  %-27s - %s" ${cmdname} "${desc###}"
  cmdstr+=$tmp
done

optparse_disp[info]="${(F)cmdstr}"
