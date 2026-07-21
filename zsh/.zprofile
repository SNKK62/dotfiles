eval "$(/opt/homebrew/bin/brew shellenv)"
# Make nix-darwin / home-manager profiles win over Homebrew for tools that
# exist in both. `brew shellenv` above prepends /opt/homebrew/bin, so re-prepend
# the Nix profile dirs here to give Nix priority. Kept before `pyenv init` so
# pyenv's Python shims still take precedence (Nix does not manage Python).
export PATH="/etc/profiles/per-user/$USER/bin:/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH"
# init pyenv
eval "$(pyenv init --path)"
