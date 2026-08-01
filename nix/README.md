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
# 1. Get the dotfiles (this repo) at ~/workspace/dotfiles
mkdir -p ~/workspace && git clone <this-repo> ~/workspace/dotfiles

# 2. Install bootstrap dependencies
cd ~/workspace/dotfiles/nix
./install.sh
```

`install.sh` installs the Xcode Command Line Tools, Homebrew, Determinate Nix,
Codex, Claude Code, rustup + Clippy, Antigen, and the pinned Cica font when
missing. It also copies the custom keyboard layout and initial Marta
configuration without overwriting existing files. Rerun the script after the
Xcode installer finishes if it was started on the first run.

Next, grant the terminal app **Full Disk Access** in System Settings > Privacy &
Security, quit and reopen the terminal, then build and switch:

```sh
cd ~/workspace/dotfiles/nix
nix run nix-darwin -- switch --flake .#koki-mac
# Subsequent rebuilds:
sudo darwin-rebuild switch --flake .#koki-mac
```

Portable tools such as `uv`, Git, Git LFS and delta are deliberately not
installed by `install.sh`; home-manager installs and configures them during the
switch.

> The dotfile symlinks in `home.nix` point at `~/workspace/dotfiles` (this
> repo's `ghq` location). If you clone elsewhere, update the `dotfiles`
> variable at the top of `home.nix`.

## What is reproduced

- **CLI tools** from nixpkgs (see `home.packages`): bat, lsd, fzf, ripgrep,
  gh, ghq, Git, Git LFS, delta, coreutils, gnutar, neovim,
  lua-language-server, luarocks, tmux, zellij, starship, fastfetch, pandoc,
  mpv, pngpaste, numbat, uv.
- **TeX** from nixpkgs (`texliveSmall.withPackages`): mirrors the collections
  currently installed under `/usr/local/texlive` — `latexmk`, `biber`,
  langjapanese, langcjk, latexextra, latexrecommended, fontsrecommended,
  pictures, metapost, xetex. Pinned by the flake, so papers build identically
  on a new machine.
- **Homebrew formulae** kept on brew (`homebrew.brews`): pyenv, n, prettierd,
  libsixel, plus the pyenv build deps (readline, openssl@3, xz, zlib, libffi,
  jpeg, tcl-tk).
- **GUI apps** via Homebrew casks (`homebrew.casks`): aerospace, wezterm,
  espanso, hammerspoon, clipy, raycast, marta, chrome, slack, obsidian,
  drawio, docker, tailscale.
- **Dotfiles** symlinked into `~/.config` and `~` (nvim, wezterm, zellij,
  espanso, tmux, zsh, starship, aerospace, hammerspoon, and the tracked Claude
  Code settings, instructions, status line, and skills).
- **Claude Code integration**: the user-scoped Codex MCP server and configured
  Context7 plugin are installed automatically during Home Manager activation
  when they are not already present.
- **Git configuration** via home-manager: identity, Vim editor, default branch,
  vimdiff merge tool, ghq root, Git LFS, delta theme/pagers, and aliases.
- **macOS defaults**: fast key repeat, press-and-hold off, show all
  extensions, displays-have-separate-spaces on, Reduce Motion on, Caps Lock
  remapped to Control, and the macOS Spotlight Command-Space shortcut off.
- **Fonts**: Hack Nerd Font, Agave Nerd Font.

## NOT reproduced automatically (install by hand)

These have no cask / aren't in nixpkgs, or come from the Mac App Store.

- **Mac App Store apps**: LINE is declared in `homebrew.masApps` and installed
  automatically — but you must **sign into the App Store first** (otherwise `mas`
  cannot download it). The rest (Xcode, Keynote, Pages, Numbers, GarageBand,
  iMovie, Microsoft Word/Excel/PowerPoint/Teams) are not declared; add them to
  `homebrew.masApps` the same way if you want them (`mas list` to get IDs).
- **Rust toolchain versions** — `install.sh` installs rustup and Clippy, but
  individual project toolchain versions are selected by rustup/project files.
- **Editor extensions**: handled by the editor's own Settings Sync.
- **Python interpreters and virtualenvs** — `pyenv` and `pyenv-virtualenv` are
  installed, but interpreters and envs are not. Install whatever each project
  needs (`pyenv install <version>`, `pyenv virtualenv <version> <name>`).
- **Node interpreters** — `n` is installed but the runtimes are not.
  Install per project with `sudo n <version>`.
- **Keyboard layout** — `install.sh` copies the custom layout; select it in
  System Settings > Keyboard > Input Sources after installation.
- **Marta config** — `install.sh` copies the initial config without overwriting
  existing files. It is not symlinked: Marta rewrites these files on save and expands
  `${user.documents}` in `favorites.marco` into absolute paths, which would
  clobber the portable version kept here. `default.marco` is Marta's shipped
  reference config — keep it for lookup, don't copy it.
- **gh auth** — re-authenticate with `gh auth login` (the token is not tracked).
- **Neovim Mason tools** — plugins are pinned by `nvim/lazy-lock.json`, but
  Mason-installed binaries are not. Run `:Mason` and install `eslint_d`,
  `stylua`, `luacheck` (see repo README).
- **macOS accessibility permissions** — AeroSpace, Hammerspoon and Espanso each
  need to be granted Accessibility/Input Monitoring access by hand on first
  launch. This cannot be automated. Also grant **Full Disk Access to the
  terminal app used to run `darwin-rebuild`** before the first switch:
  `system.defaults.universalaccess.reduceMotion = true` is declarative, but
  macOS protects the underlying `com.apple.universalaccess` preference.
- **Raycast shortcut** — nix-darwin disables Spotlight's Command-Space shortcut,
  leaving it available for Raycast. The Homebrew cask only installs Raycast; it
  does not configure the app's preferences. On first launch, choose
  **Command-Space** as Raycast's global hotkey.
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
