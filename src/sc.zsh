emulate -R zsh
setopt localloops localtraps localpatterns functionargzero

zmodload zsh/datetime
zmodload zsh/stat

source "${sc_path}/deps/optparse/optparse.zsh"

source "${sc_path}/src/sc/cli.zsh"
source "${sc_path}/src/sc/config.zsh"
source "${sc_path}/src/sc/core.zsh"
source "${sc_path}/src/sc/globals.zsh"
source "${sc_path}/src/sc/jq.zsh"
source "${sc_path}/src/sc/options.zsh"
source "${sc_path}/src/sc/strings.zsh"
source "${sc_path}/src/sc/url.zsh"
source "${sc_path}/src/sc/util.zsh"
source "${sc_path}/src/sc/wcache.zsh"
