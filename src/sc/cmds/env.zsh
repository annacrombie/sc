#print sc's execution environment.
cmd_env_() {
  typeset -a bins=(find jq mktemp ln tree zsh column)
  typeset bin
  typeset missing=()
  setopt localoptions pipefail

  echo "required commands\n---"

  for bin in ${(i)bins}; do
    whence "$bin" >/dev/null

    if [[ $? -eq 0 ]]; then
      typeset ver=$("$bin" --version 2>/dev/null | head -n 1)
      if [[ $? -eq 0 ]]; then
        echo "\e[32m${bin}\e[0m found! (${ver})"
      else
        echo "\e[32m${bin}\e[0m found, but doesn't have --version arg"
      fi
    else
      echo "\e[31m${bin}\e[0m not found"
      missing+="$bin"
    fi
  done

  if [[ $#missing -gt 0 ]]; then
    echo "\e[31muh-oh\e[0m missing commands: ${missing}"
  fi

  echo "\ngit status\n---"
  echo " $(git rev-parse HEAD) sc"
  git submodule status --recursive

  echo "\nenvironment\n---"
  [[ -n "$sc_key" ]] && sc_key=${sc_key//[[:alnum:]]/x}

  typeset -m 'sc_*' | sort
  typeset -m PWD
}
