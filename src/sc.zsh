emulate -R zsh
setopt localloops localtraps localpatterns functionargzero

source "${sc_path}/optparse.zsh"

source "${sc_path}/src/cli.zsh"
source "${sc_path}/src/globals.zsh"
source "${sc_path}/src/keys.zsh"
source "${sc_path}/src/options.zsh"
source "${sc_path}/src/api.zsh"
source "${sc_path}/src/strings.zsh"
source "${sc_path}/src/url.zsh"
source "${sc_path}/src/util.zsh"
