#!/usr/bin/env zsh
zsh util/preflight.zsh || { echo "preflight failed" && exit 1 }
zsh test/_suite.zsh $@
