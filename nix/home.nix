{ config, pkgs, username, ... }:

let
  # Live path to this dotfiles repo. Symlinks below point here directly (via
  # mkOutOfStoreSymlink) so edits in the repo are reflected immediately — same
  # behaviour as the manual `ln -s` calls documented in the repo README.
  dotfiles = "${config.home.homeDirectory}/workspace/dotfiles";
  link = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.username = username;
  home.homeDirectory = "/Users/${username}";

  # Bump only when the home-manager changelog says to.
  home.stateVersion = "24.11";

  # ---------------------------------------------------------------------------
  # Portable CLI tooling from nixpkgs (replaces the Homebrew "leaves").
  # macOS-specific / Japanese-NLP / build-toolchain formulae stay on Homebrew
  # (see darwin.nix).
  # ---------------------------------------------------------------------------
  home.packages = with pkgs; [
    # shell / navigation
    bat
    lsd
    fzf
    ripgrep
    ghq
    gh
    delta            # git-delta
    coreutils
    gnutar           # gnu-tar
    tmux
    zellij
    starship
    neofetch

    # editors / lsp
    neovim
    lua-language-server
    luarocks
    lld

    # docs / media
    pandoc
    graphviz
    imagemagick
    ghostscript
    mpv
    yt-dlp
    pngpaste
    numbat

    # dev runtimes / tools
    uv
    deno
    qemu
    ttyd
    vhs
  ];

  # ---------------------------------------------------------------------------
  # Environment (mirrors zsh/.zshenv). ZDOTDIR itself is set in /etc/zshenv by
  # nix-darwin so ~/.config/zsh (linked below) is loaded.
  # ---------------------------------------------------------------------------
  home.sessionVariables = {
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
    XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
    XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
    XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";

    EDITOR = "vim";
    GIT_EDITOR = "vim";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";

    GOPATH = "${config.home.homeDirectory}/go";
  };

  # ---------------------------------------------------------------------------
  # Dotfile symlinks — recreate every `ln -s` from the repo README.
  # ---------------------------------------------------------------------------

  # ~/.config/<name> -> repo
  xdg.configFile = {
    "nvim".source = link "${dotfiles}/nvim";
    "wezterm".source = link "${dotfiles}/wezterm";
    "zellij".source = link "${dotfiles}/zellij";
    "espanso".source = link "${dotfiles}/espanso";
    "tmux".source = link "${dotfiles}/tmux";
    "zsh".source = link "${dotfiles}/zsh";
    "starship.toml".source = link "${dotfiles}/starship/starship.toml";
    # aerospace links only the toml file (matches current setup).
    "aerospace/aerospace.toml".source = link "${dotfiles}/aerospace/aerospace.toml";
  };

  # ~/.hammerspoon -> repo/.hammerspoon
  home.file.".hammerspoon".source = link "${dotfiles}/.hammerspoon";

  # ---------------------------------------------------------------------------
  # Let home-manager manage itself.
  # ---------------------------------------------------------------------------
  programs.home-manager.enable = true;
}
