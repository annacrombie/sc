#!/usr/bin/env zsh

typeset -g sc_exec="${0:A}"
typeset -g sc_path="${0:A:h}"

source "${sc_path}/src/sc.zsh"

sc_cli_main_ "$@"
