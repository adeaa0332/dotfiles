export PATH="$PATH:/Users/abeeradeel/Documents/flutter/bin"


# OrbStack CLI (docker, docker compose, kubectl). Added manually because
# OrbStack's GUI onboarding, which normally creates ~/.orbstack/bin, has not run.
export PATH="/Applications/OrbStack.app/Contents/MacOS/xbin:$PATH"
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source <(fzf --zsh)
