# nix — reproduce this Mac

Declarative macOS setup for `kokiseno` using **nix-darwin + home-manager**,
with **Homebrew** (managed by nix-darwin) for GUI apps and a few
macOS-specific / Japanese-NLP / build-toolchain formulae.

- Machine: Apple Silicon (`aarch64-darwin`), macOS 26.x
- Host name: `KokinoMacBook-Pro` (edit `hostname` in `flake.nix` if it differs)
- User: `kokiseno`

## Layout

| file         | what it does |
|--------------|--------------|
| `flake.nix`  | inputs (nixpkgs, nix-darwin, home-manager) and the `darwinConfigurations` |
| `darwin.nix` | system config: Homebrew taps/brews/casks, macOS `defaults`, zsh, fonts |
| `home.nix`   | user CLI packages from nixpkgs + dotfile symlinks + env vars |

## Bootstrap on a fresh Mac

```sh
# 1. Xcode command line tools
xcode-select --install

# 2. Install Homebrew (nix-darwin manages packages but does not install brew)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 3. Install Nix (official installer; this config sets nix.enable = true).
#    If you prefer the Determinate Systems installer, set `nix.enable = false`
#    in darwin.nix (it manages the daemon itself).
sh <(curl -L https://nixos.org/nix/install)

# 4. Get the dotfiles (this repo) at ~/workspace/dotfiles
mkdir -p ~/workspace && git clone <this-repo> ~/workspace/dotfiles

# 5. Build & switch
cd ~/workspace/dotfiles/nix
nix run nix-darwin -- switch --flake .#KokinoMacBook-Pro
#   (subsequent rebuilds: darwin-rebuild switch --flake .#KokinoMacBook-Pro)
```

> The dotfile symlinks in `home.nix` point at `~/workspace/dotfiles` (this
> repo's `ghq` location). If you clone elsewhere, update the `dotfiles`
> variable at the top of `home.nix`.

## What is reproduced

- **CLI tools** from nixpkgs (see `home.packages`): bat, lsd, fzf, ripgrep,
  gh, ghq, delta, neovim, tmux, zellij, starship, pandoc, imagemagick,
  ghostscript, mpv, yt-dlp, uv, deno, qemu, ttyd, vhs, lua-language-server, …
- **Homebrew formulae** kept on brew (`homebrew.brews`): yabai, pyenv, opam,
  n, prettierd, cabocha/crf++/mecab/mecab-ipadic (Japanese NLP), tesseract,
  plus the pyenv build deps (readline, openssl@3, xz, zlib, libffi, jpeg,
  tcl-tk, libsixel).
- **GUI apps** via Homebrew casks (`homebrew.casks`): aerospace, espanso,
  marta, wezterm, iterm2, warp, vscode, cursor, chrome, slack, zoom, notion,
  obsidian, raycast, clipy, drawio, hammerspoon, keycastr, tailscale,
  docker, anydesk, vnc-viewer, basictex.
- **Dotfiles** symlinked into `~/.config` and `~` (nvim, wezterm, zellij,
  espanso, tmux, zsh, starship, aerospace, hammerspoon).
- **macOS defaults**: fast key repeat, press-and-hold off, show all
  extensions, reduce motion on, displays-have-separate-spaces on.
- **Fonts**: Hack Nerd Font, Agave Nerd Font.

## NOT reproduced automatically (install by hand)

These have no cask / aren't in nixpkgs, or come from the Mac App Store.

- **Mac App Store apps**: Xcode, Keynote, Pages, Numbers, GarageBand, iMovie,
  LINE, Microsoft Word/Excel/PowerPoint/Teams. Install `mas` and add them to
  `homebrew.masApps` if you want them declarative
  (`brew install mas`, then `mas list` to get IDs).
- **Manually-downloaded apps**: Anaconda-Navigator, Canon Utilities,
  Cisdem Video Converter, CloudCompare, Fiji / ImageJ, Eclipse,
  Blackmagic tools, Logi Options / Bolt, Nota.
- **Rust toolchain**: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
  then `rustup component add clippy` (see repo README).
- **Editor extensions**: VS Code / Cursor extensions are handled by each
  editor's own Settings Sync (not managed here). Lists are in the repo.
- **Japanese programming fonts** Cica / Sarasa / HackGen — download from their
  releases into `~/Library/Fonts` (not in nixpkgs).
- **Antigen** (zsh plugin manager, per repo README):
  `curl -L git.io/antigen > ~/.local/bin/antigen.zsh`

## Notes

- `homebrew.onActivation.cleanup = "none"` keeps hand-installed brews. Set it
  to `"zap"` in `darwin.nix` for a strictly reproducible machine (this will
  **uninstall** anything not listed here).
- Some cask names drift over time (e.g. `docker-desktop`, `tailscale-app`). If
  a cask fails to install, run `brew search <name>` and update `darwin.nix`.
