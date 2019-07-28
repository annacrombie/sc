#!/usr/bin/env zsh

typeset -g mu_exec="${0:A}"
typeset -g mu_path="${0:A:h}"
typeset defbackend=sc

source "${mu_path}/src/mu.zsh"

case $1 in
  (bc | sc) load_backend_ "$1"; shift;;
  *) load_backend_ "$defbackend"
esac

mu_cli_main_ "$@"
