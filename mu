#!/usr/bin/env zsh

typeset -g mu_exec="${0:A}"
typeset -g mu_path="${0:A:h}"

source "${mu_path}/src/mu.zsh"

mu_cli_main_ "$@"
