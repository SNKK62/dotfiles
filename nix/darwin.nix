{ pkgs, username, hostname, ... }:

{
  # ---------------------------------------------------------------------------
  # Core nix-darwin
  # ---------------------------------------------------------------------------
  # Bump this only when the nix-darwin changelog tells you to.
  system.stateVersion = 6;

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # The primary (and only) interactive user of this machine.
  system.primaryUser = username;
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  networking.hostName = hostname;
  networking.localHostName = hostname;
  networking.computerName = "KokiのMacBook Pro";

  # ---------------------------------------------------------------------------
  # Nix daemon / flakes
  # ---------------------------------------------------------------------------
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    # Speed up builds via the community cache (optional but recommended).
    trusted-users = [ "root" username ];
  };
  # nix-darwin now recommends letting the Determinate/official installer own the
  # daemon; set to false only if you use Determinate Nix. Default true is fine
  # for the standard installer.
  nix.enable = true;

  # ---------------------------------------------------------------------------
  # Shell (zsh). Mirrors the existing setup where /etc/zshenv points ZDOTDIR at
  # ~/.config/zsh (see repo README "zsh" section).
  # ---------------------------------------------------------------------------
  programs.zsh.enable = true;

  # Recreate `/etc/zshenv` with `ZDOTDIR=$HOME/.config/zsh` so zsh loads the
  # dotfiles from ~/.config/zsh (symlinked to this repo by home-manager below).
  environment.etc."zshenv".text = ''
    ZDOTDIR=$HOME/.config/zsh
  '';

  environment.shells = [ pkgs.zsh ];

  # ---------------------------------------------------------------------------
  # Fonts (Nerd Fonts used by wezterm / neovim / starship).
  # These replace the manually-installed fonts under ~/Library/Fonts.
  # ---------------------------------------------------------------------------
  fonts.packages = with pkgs; [
    nerd-fonts.hack
    nerd-fonts.agave
    # Japanese-capable programming fonts (Cica / Sarasa / HackGen are not in
    # nixpkgs; install those manually if needed — see nix/README.md).
  ];

  # ---------------------------------------------------------------------------
  # Homebrew — managed declaratively by nix-darwin.
  # Requires Homebrew to be installed first (see nix/README.md).
  # GUI apps (casks) and macOS-specific / Japanese-NLP / build-toolchain
  # formulae stay on brew; portable CLI tools come from nixpkgs (see home.nix).
  # ---------------------------------------------------------------------------
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      # "none" is non-destructive (keeps brews you install by hand).
      # Switch to "zap" for a strict, fully-reproducible machine.
      cleanup = "none";
    };

    taps = [
      "koekeishiya/formulae" # yabai
      "nikitabobko/tap"      # aerospace
      "fsouza/prettierd"     # prettierd
    ];

    # Formulae kept on Homebrew (not in nixpkgs, macOS-specific, or part of the
    # pyenv build toolchain).
    brews = [
      "koekeishiya/formulae/yabai" # tiling window manager (SIP-sensitive)
      "pyenv"          # python version manager (README python workflow)
      "opam"           # OCaml package manager (README ocaml workflow)
      "n"              # node version manager
      "fsouza/prettierd/prettierd"
      "cabocha"        # Japanese dependency parser (not in nixpkgs)
      "crf++"          # CRF toolkit (cabocha dependency)
      "mecab"          # Japanese morphological analyzer
      "mecab-ipadic"   # mecab dictionary
      "tesseract"      # OCR
      "screenresolution"
      # pyenv build dependencies (see README "Python" section):
      "readline"
      "openssl@3"
      "xz"
      "zlib"
      "libffi"
      "jpeg"
      "tcl-tk"
      "libsixel"
    ];

    # GUI applications. Currently brew-managed: aerospace, basictex, espanso,
    # marta, wezterm. The rest were previously installed by hand and are added
    # here so a fresh Mac reproduces them. Apps only on the Mac App Store or
    # with no cask are listed in nix/README.md instead.
    casks = [
      # already brew-managed
      "nikitabobko/tap/aerospace"
      "basictex"
      "espanso"
      "marta"
      "wezterm"

      # terminals / editors
      "iterm2"
      "warp"
      "visual-studio-code"
      "cursor"

      # browsers & comms
      "google-chrome"
      "slack"
      "zoom"

      # notes / productivity
      "notion"
      "obsidian"
      "raycast"
      "clipy"
      "drawio"

      # utilities
      "hammerspoon"
      "keycastr"
      "tailscale-app"
      "docker-desktop"
      "anydesk"
      "vnc-viewer"
    ];
  };

  # ---------------------------------------------------------------------------
  # macOS system defaults — captured from the current machine.
  # (KeyRepeat=2, InitialKeyRepeat=15, ApplePressAndHold=off,
  #  ShowAllExtensions=on, reduceMotion=on, Light appearance.)
  # ---------------------------------------------------------------------------
  system.defaults = {
    NSGlobalDomain = {
      # Fast key repeat, disable press-and-hold (better for vim/nvim).
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
      # Light mode (AppleInterfaceStyle unset on this machine).
      AppleInterfaceStyle = null;
    };

    dock = {
      # Mission Control: keep spaces stable (helpful with aerospace/yabai).
      mru-spaces = false;
    };

    finder = {
      AppleShowAllExtensions = true;
    };
  };

  # Settings without a typed nix-darwin option go here (written verbatim via
  # `defaults`). These match the README "Mac Mission Control settings".
  system.defaults.CustomUserPreferences = {
    # System Settings > Accessibility > Display > Reduce motion: ON
    "com.apple.universalaccess" = {
      reduceMotion = true;
    };
    # System Settings > Desktop & Dock > Mission Control:
    # "Displays have separate Spaces" ON  ==  spans-displays = 0
    "com.apple.spaces" = {
      "spans-displays" = 0;
    };
  };

}
