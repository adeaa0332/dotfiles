#!/usr/bin/env bash
#
# bootstrap.sh — set up a new Mac from this dotfiles repo.
# Run once after cloning:  cd ~/dotfiles && ./bootstrap.sh
#
# Idempotent: safe to re-run. Existing files are backed up to *.bak before linking.

set -euo pipefail

# Resolve the repo directory (where this script lives), so symlinks point back here.
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m warn:\033[0m %s\n' "$*"; }

# ------------------------------------------------------------
# 1. Homebrew
# ------------------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  info "Homebrew already installed."
fi

# Load brew into THIS shell (path differs: Apple Silicon vs Intel).
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# ------------------------------------------------------------
# 2. Packages from the Brewfile
# ------------------------------------------------------------
if [ -f "$REPO/Brewfile" ]; then
  info "Installing packages from Brewfile (this can take a while)..."
  brew bundle install --file="$REPO/Brewfile"
else
  warn "No Brewfile in repo — skipping package install."
fi

# ------------------------------------------------------------
# 3. Symlink dotfiles into place
# ------------------------------------------------------------
# Format:  "source-in-repo : target-in-home"
# Sources that don't exist in the repo are skipped, so this list can be a superset.
LINKS=(
  ".zshrc:$HOME/.zshrc"
  ".gitconfig:$HOME/.gitconfig"
  ".tmux.conf:$HOME/.tmux.conf"
  "nvim:$HOME/.config/nvim"
)

link_one() {
  local src="$REPO/$1" dest="$2"

  if [ ! -e "$src" ]; then
    return 0   # nothing to link; silently skip
  fi

  mkdir -p "$(dirname "$dest")"

  # If the correct symlink already exists, leave it.
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    info "ok: $dest -> $src"
    return 0
  fi

  # Back up anything real that's already there.
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    warn "backing up existing $dest -> $dest.bak"
    rm -rf "$dest.bak"
    mv "$dest" "$dest.bak"
  fi

  ln -s "$src" "$dest"
  info "linked: $dest -> $src"
}

info "Linking dotfiles..."
for pair in "${LINKS[@]}"; do
  link_one "${pair%%:*}" "${pair#*:}"
done

# ------------------------------------------------------------
# 4. Done — what's left is intentionally manual
# ------------------------------------------------------------
cat <<'EOF'

Done. A few things finish themselves on first use:

  • Neovim  — launch `nvim`; mini.deps bootstraps and pulls every plugin,
              then Mason installs the LSP servers in your ensure_installed list.
              Run :DepsUpdate and :Mason afterward to confirm.
  • fzf     — if Ctrl-T / Alt-C don't respond, open a fresh shell so
              `source <(fzf --zsh)` in your .zshrc loads.
  • Terminal.app — re-check "Use Option as Meta key" (Settings ▸ Profiles ▸
              Keyboard); that's a per-app setting, not a dotfile.

Open a new terminal window to pick up the linked .zshrc.
EOF
