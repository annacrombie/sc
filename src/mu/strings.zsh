optparse_disp[banner]="mu version $mu_version
Usage: mu [OPTIONS] COMMAND [OPTIONS]"
optparse_disp[desc]="A lightweight client for music streaming services"

typeset cmd tmp
typeset -a cmdstr=("COMMANDS:")

for dir in $mu_cmd_dirs; do
  for cmd in $dir/*.zsh; do
    typeset cmdname="${${cmd:t}%%.zsh}"
    typeset desc="$(head -n 1 "$cmd")"
    printf -v tmp "  %-27s - %s" ${cmdname} "${desc###}"
    cmdstr+=$tmp
  done
done

optparse_disp[info]="${(F)cmdstr}"
