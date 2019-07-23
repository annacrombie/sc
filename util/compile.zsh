#!/usr/bin/env zsh

typeset -g mu_path="${${0:A:h}:h}"

for file in "$mu_path"/src/**/*.zsh; do
  zcompile "$file"
done
