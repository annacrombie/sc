emulate -R zsh
setopt localloops localtraps localpatterns functionargzero

zmodload zsh/datetime
zmodload zsh/stat

source "${mu_path}/deps/optparse/optparse.zsh"
source "${mu_path}/deps/zsh-util/util.zsh"

source "${mu_path}/src/mu/cli.zsh"
source "${mu_path}/src/mu/config.zsh"
source "${mu_path}/src/mu/globals.zsh"
source "${mu_path}/src/mu/jq.zsh"
source "${mu_path}/src/mu/options.zsh"
source "${mu_path}/src/mu/strings.zsh"
source "${mu_path}/src/mu/url.zsh"
source "${mu_path}/src/mu/util.zsh"
source "${mu_path}/src/mu/wcache.zsh"
