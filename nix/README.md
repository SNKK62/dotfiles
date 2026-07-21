# nix — reproduce this Mac

Declarative macOS setup for `kokiseno` using **nix-darwin + home-manager**,
with **Homebrew** (managed by nix-darwin) for GUI apps and a few
macOS-specific / Japanese-NLP / build-toolchain formulae.

- Machine: Apple Silicon (`aarch64-darwin`), macOS 26.x
- Host name: `koki-mac` (set by `hostname` in `flake.nix`; change it there to rename)
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

# 3. Install Nix. This config uses Determinate Nix (darwin.nix sets
#    nix.enable = false so nix-darwin does NOT fight Determinate's daemon).
#    Install Determinate to match:
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
#    (If you instead use the OFFICIAL installer below, flip nix.enable = true
#     and restore the nix.settings block in darwin.nix.)
#    sh <(curl -L https://nixos.org/nix/install)

# 4. Get the dotfiles (this repo) at ~/workspace/dotfiles
mkdir -p ~/workspace && git clone <this-repo> ~/workspace/dotfiles

# 5. Build & switch
cd ~/workspace/dotfiles/nix
nix run nix-darwin -- switch --flake .#koki-mac
#   (subsequent rebuilds: darwin-rebuild switch --flake .#koki-mac)
```

> The dotfile symlinks in `home.nix` point at `~/workspace/dotfiles` (this
> repo's `ghq` location). If you clone elsewhere, update the `dotfiles`
> variable at the top of `home.nix`.

## What is reproduced

- **CLI tools** from nixpkgs (see `home.packages`): bat, lsd, fzf, ripgrep,
  gh, ghq, delta, coreutils, gnutar, neovim, lua-language-server, luarocks,
  tmux, zellij, starship, fastfetch, pandoc, mpv, pngpaste, numbat, uv.
- **TeX** from nixpkgs (`texliveSmall.withPackages`): mirrors the collections
  currently installed under `/usr/local/texlive` — langjapanese, langcjk,
  latexextra, latexrecommended, fontsrecommended, pictures, metapost, xetex.
  Pinned by the flake, so papers build identically on a new machine.
- **Homebrew formulae** kept on brew (`homebrew.brews`): pyenv, n, prettierd,
  libsixel, plus the pyenv build deps (readline, openssl@3, xz, zlib, libffi,
  jpeg, tcl-tk).
- **GUI apps** via Homebrew casks (`homebrew.casks`): aerospace, wezterm,
  espanso, hammerspoon, clipy, raycast, marta, chrome, slack, obsidian,
  drawio, docker, tailscale.
- **Dotfiles** symlinked into `~/.config` and `~` (nvim, wezterm, zellij,
  espanso, tmux, zsh, starship, aerospace, hammerspoon).
- **macOS defaults**: fast key repeat, press-and-hold off, show all
  extensions, reduce motion on, displays-have-separate-spaces on.
- **Fonts**: Hack Nerd Font, Agave Nerd Font.

## NOT reproduced automatically (install by hand)

These have no cask / aren't in nixpkgs, or come from the Mac App Store.

- **Mac App Store apps**: LINE is declared in `homebrew.masApps` and installed
  automatically — but you must **sign into the App Store first** (otherwise `mas`
  cannot download it). The rest (Xcode, Keynote, Pages, Numbers, GarageBand,
  iMovie, Microsoft Word/Excel/PowerPoint/Teams) are not declared; add them to
  `homebrew.masApps` the same way if you want them (`mas list` to get IDs).
- **Rust toolchain**: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
  then `rustup component add clippy` (see repo README).
- **Editor extensions**: handled by the editor's own Settings Sync.
- **Cica font**: not packaged in nixpkgs — download `Cica.ttc` from
  https://github.com/miiton/Cica/releases into `~/Library/Fonts`.
  (HackGen and Sarasa *are* installed from nixpkgs via `fonts.packages`.)
- **Antigen** (zsh plugin manager, per repo README):
  `curl -L git.io/antigen > ~/.local/bin/antigen.zsh`
- **Python interpreters and virtualenvs** — `pyenv` and `pyenv-virtualenv` are
  installed, but interpreters and envs are not. Install whatever each project
  needs (`pyenv install <version>`, `pyenv virtualenv <version> <name>`).
- **Node interpreters** — `n` is installed but the runtimes are not.
  Install per project with `sudo n <version>`.
- **Keyboard layout** — copy the custom layout into place, then select it in
  System Settings > Keyboard > Input Sources:
  ```sh
  cp mac/option_blank_layout.keylayout ~/Library/Keyboard\ Layouts/
  ```
- **Marta config** — copy into `~/Library/Application Support/org.yanex.marta/`:
  ```sh
  cp mac/marta/conf.marco mac/marta/favorites.marco \
     ~/Library/Application\ Support/org.yanex.marta/
  ```
  Not symlinked on purpose: Marta rewrites these files on save and expands
  `${user.documents}` in `favorites.marco` into absolute paths, which would
  clobber the portable version kept here. `default.marco` is Marta's shipped
  reference config — keep it for lookup, don't copy it.
- **gh auth** — re-authenticate with `gh auth login` (the token is not tracked).
- **Neovim Mason tools** — plugins are pinned by `nvim/lazy-lock.json`, but
  Mason-installed binaries are not. Run `:Mason` and install `eslint_d`,
  `stylua`, `luacheck` (see repo README).
- **macOS accessibility permissions** — AeroSpace, Hammerspoon and Espanso each
  need to be granted Accessibility/Input Monitoring access by hand on first
  launch. This cannot be automated.
- **neofetch → fastfetch**: neofetch was removed from nixpkgs (upstream
  archived) and disabled in Homebrew on 2025-05-04, so it can no longer be
  installed on a fresh Mac. `home.nix` ships `fastfetch` instead. The existing
  `~/.config/neofetch/config.conf` is **not** read by fastfetch — port it to
  `~/.config/fastfetch/config.jsonc` if you want the same output.

## Notes

- `homebrew.onActivation.cleanup = "none"` keeps hand-installed brews. Set it
  to `"zap"` in `darwin.nix` for a strictly reproducible machine (this will
  **uninstall** anything not listed here).
- Some cask names drift over time (e.g. `docker-desktop`, `tailscale-app`). If
  a cask fails to install, run `brew search <name>` and update `darwin.nix`.
- **Version pinning is asymmetric**: everything from nixpkgs (CLI tools, TeX,
  fonts) is pinned by `flake.lock` and reproduces exactly. Homebrew brews and
  casks always resolve to *latest* — Homebrew has no lockfile. Commit
  `flake.lock` so the nixpkgs half stays reproducible.
