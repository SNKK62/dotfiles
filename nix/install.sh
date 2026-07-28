#!/bin/sh

set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
dotfiles_dir=$(dirname "$script_dir")

if ! xcode-select -p >/dev/null 2>&1; then
  echo "Installing the Xcode Command Line Tools. Rerun this script after the installer finishes."
  xcode-select --install
  exit 0
fi

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if ! command -v nix >/dev/null 2>&1; then
  curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
fi

# The remaining tools/configuration are intentionally outside Nix:
# Codex and Claude Code use their official self-updating installers; rustup
# manages project-specific Rust toolchains; Antigen is sourced directly by
# zsh/.zshrc.
if ! command -v codex >/dev/null 2>&1; then
  curl -fsSL https://chatgpt.com/codex/install.sh | sh
fi

if ! command -v claude >/dev/null 2>&1; then
  curl -fsSL https://claude.ai/install.sh | bash
fi

if ! command -v rustup >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
"$HOME/.cargo/bin/rustup" component add clippy

mkdir -p "$HOME/.local/bin"
if [ ! -f "$HOME/.local/bin/antigen.zsh" ]; then
  curl -fsSL https://git.io/antigen -o "$HOME/.local/bin/antigen.zsh"
fi

# Cica is not packaged by nixpkgs. Pin the upstream archive and verify it so a
# fresh machine gets the same font rather than whatever "latest" means.
fonts_dir="$HOME/Library/Fonts"
mkdir -p "$fonts_dir"
if [ ! -f "$fonts_dir/Cica-Regular.ttf" ]; then
  cica_tmp=$(mktemp -d)
  trap 'rm -rf "$cica_tmp"' EXIT HUP INT TERM
  cica_zip="$cica_tmp/Cica_v5.0.3.zip"
  curl -fsSL \
    https://github.com/miiton/Cica/releases/download/v5.0.3/Cica_v5.0.3.zip \
    -o "$cica_zip"
  echo "cbd1bcf1f3fd1ddbffe444369c76e42529add8538b25aeb75ab682d398b0506f  $cica_zip" \
    | shasum -a 256 -c -
  ditto -x -k "$cica_zip" "$cica_tmp/unpacked"
  find "$cica_tmp/unpacked" -type f \( -name '*.ttf' -o -name '*.ttc' \) \
    -exec cp -n {} "$fonts_dir/" \;
  rm -rf "$cica_tmp"
  trap - EXIT HUP INT TERM
fi

# Files owned and rewritten by their applications are copied rather than
# symlinked. Existing local customizations are never overwritten.
mkdir -p "$HOME/Library/Keyboard Layouts"
cp -n "$dotfiles_dir/mac/option_blank_layout.keylayout" \
  "$HOME/Library/Keyboard Layouts/"

marta_dir="$HOME/Library/Application Support/org.yanex.marta"
mkdir -p "$marta_dir"
cp -n "$dotfiles_dir/mac/marta/conf.marco" "$marta_dir/"
cp -n "$dotfiles_dir/mac/marta/favorites.marco" "$marta_dir/"

echo
echo "Bootstrap dependencies are installed."
echo "Grant this terminal Full Disk Access, then run:"
echo "  nix run nix-darwin -- switch --flake $script_dir#koki-mac"
