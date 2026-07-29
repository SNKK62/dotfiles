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
  networking.computerName = "koki-mac";

  # ---------------------------------------------------------------------------
  # Nix daemon / flakes
  # ---------------------------------------------------------------------------
  # This machine uses Determinate Nix, which owns the Nix installation and its
  # daemon. nix-darwin must NOT manage Nix here, otherwise activation aborts.
  # Consequence: nix-darwin cannot set `nix.*` (experimental-features,
  # trusted-users, etc.) — Determinate handles those. flakes/nix-command are
  # enabled by Determinate's default config, and the installing user is already
  # in trusted-users. On a fresh Mac WITHOUT Determinate, set this back to true
  # and restore the `nix.settings` block.
  nix.enable = false;

  # ---------------------------------------------------------------------------
  # Shell (zsh). Mirrors the existing setup where /etc/zshenv points ZDOTDIR at
  # ~/.config/zsh (see repo README "zsh" section).
  # ---------------------------------------------------------------------------
  programs.zsh.enable = true;

  # Recreate `/etc/zshenv` with `ZDOTDIR=$HOME/.config/zsh` so zsh loads the
  # dotfiles from ~/.config/zsh (symlinked to this repo by home-manager below).
  # The Determinate installer also drops a guarded block here that sources Nix
  # for non-interactive SSH shells; keep it so SSH sessions still see Nix. The
  # `[ -e ... ]` guard makes it a no-op on a machine without Determinate.
  environment.etc."zshenv".text = ''
    # Set up Nix only on SSH connections
    # See: https://github.com/DeterminateSystems/nix-installer/pull/714
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ] && [ -n "''${SSH_CONNECTION:-}" ] && [ "''${SHLVL:-0}" -eq 1 ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    # End Nix
    ZDOTDIR=$HOME/.config/zsh
  '';

  environment.shells = [ pkgs.zsh ];

  # ---------------------------------------------------------------------------
  # Fonts (Nerd Fonts used by wezterm / neovim / starship).
  # These replace the manually-installed fonts under ~/Library/Fonts.
  # ---------------------------------------------------------------------------
  fonts.packages = with pkgs; [
    # HackGen35 Console NF is referenced by wezterm/wezterm.lua and
    # nvim/lua/base.lua. Without it both fall back to a default font.
    hackgen-nf-font
    nerd-fonts.agave
    sarasa-gothic
    # Cica is not packaged in nixpkgs — install it manually (see nix/README.md).
  ];

  # ---------------------------------------------------------------------------
  # Homebrew — managed declaratively by nix-darwin.
  # Requires Homebrew to be installed first (see nix/README.md).
  # GUI apps (casks) and the version-manager / CPython-build formulae stay on
  # brew; portable CLI tools come from nixpkgs (see home.nix).
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
      "nikitabobko/tap"      # aerospace
      "fsouza/prettierd"     # prettierd
    ];

    # Formulae kept on Homebrew (not in nixpkgs, macOS-specific, or part of the
    # pyenv build toolchain).
    brews = [
      "pyenv"            # python version manager (README python workflow)
      "pyenv-virtualenv" # required by `pyenv activate` in zsh/.zshrc
      "n"                # node version manager (the active node comes from n)
      "mas"              # Mac App Store CLI (drives homebrew.masApps below)
      "fsouza/prettierd/prettierd"
      "libsixel"       # sixel graphics in the terminal
      # pyenv build dependencies (see README "Python" section):
      "readline"
      "openssl@3"
      "xz"
      "zlib"
      "libffi"
      "jpeg"
      "tcl-tk"
    ];

    # GUI applications. Apps only on the Mac App Store, or with no cask, are
    # listed in nix/README.md instead.
    # NOTE: TeX is NOT installed via the basictex cask anymore — it comes from
    # nixpkgs texlive in home.nix so the exact package set is pinned by the flake.
    casks = [
      # window management / terminal / input
      "nikitabobko/tap/aerospace"
      "wezterm"
      "espanso"
      "hammerspoon"
      "clipy"
      "raycast"

      # file manager
      "marta"

      # browsers & comms
      "google-chrome"
      "slack"

      # notes / diagrams
      "obsidian"
      "drawio"

      # dev / network
      "docker-desktop"
      "tailscale-app"

      # comms
      "zoom"
    ];

    # Mac App Store apps. Requires being signed into the App Store first;
    # `mas` (declared in brews above) performs the install.
    masApps = {
      "LINE" = 539883307;
    };
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

    universalaccess = {
      # System Settings > Accessibility > Display > Reduce motion.
      # Writing this protected preference requires Full Disk Access for the
      # terminal that runs darwin-rebuild (see README).
      reduceMotion = true;
    };
  };

  # Settings without a typed nix-darwin option go here (written verbatim via
  # `defaults`). These match the README "Mac Mission Control settings".
  system.defaults.CustomUserPreferences = {
    # System Settings > Desktop & Dock > Mission Control:
    # "Displays have separate Spaces" ON  ==  spans-displays = 0
    "com.apple.spaces" = {
      "spans-displays" = 0;
    };
  };

  # System Settings > Keyboard > Keyboard Shortcuts > Modifier Keys.
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  # Disable "Show Spotlight search" (symbolic hotkey 64) so Command-Space is
  # available to Raycast. `-dict-add` is intentional: declaring this through
  # CustomUserPreferences would replace the entire AppleSymbolicHotKeys dict
  # and discard unrelated shortcuts.
  system.activationScripts.postActivation.text = ''
    launchctl asuser "$(id -u -- ${username})" sudo --user=${username} -- \
      defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 \
      '<dict><key>enabled</key><false/><key>value</key><dict><key>parameters</key><array><integer>65535</integer><integer>49</integer><integer>1048576</integer></array><key>type</key><string>standard</string></dict></dict>'

    # `defaults`' old-style plist syntax turns these values into strings, which
    # macOS ignores. The XML above preserves Boolean/Integer types. Refresh the
    # user preference cache so the shortcut changes without requiring a reboot.
    launchctl asuser "$(id -u -- ${username})" sudo --user=${username} -- \
      killall cfprefsd 2>/dev/null || true
    launchctl asuser "$(id -u -- ${username})" sudo --user=${username} -- \
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}
