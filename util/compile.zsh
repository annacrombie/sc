#!/bin/zsh

typeset -g sc_path="${${0:A:h}:h}"

for file in "$sc_path"/src/**/*.zsh; do
  zcompile "$file"

  if [[ "${file:a:h}" == "$sc_path/src/sc/cmds" ]]; then
    mv -f "${file}.zwc" "${file:h}/cmd_${${file:t}%%.zsh}_.zwc"
    continue
  fi
done
