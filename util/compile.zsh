#!/bin/zsh

typeset -g sc_path="${${0:A:h}:h}"

for file in "$sc_path"/src/**/*.zsh; do
  zcompile "$file"
done
