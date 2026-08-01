{ config, pkgs, username, pinnedNeovim, ... }:

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
  # Portable CLI tooling from nixpkgs. Version-managers (pyenv, n) and the
  # CPython build dependencies stay on Homebrew (see darwin.nix).
  # ---------------------------------------------------------------------------
  home.packages = with pkgs; [
    # shell / navigation
    bat
    lsd
    fzf
    ripgrep
    ghq
    gh
    coreutils
    gnutar           # gnu-tar
    jq               # used by the Claude Code status line
    tmux
    zellij
    starship
    # neofetch was removed from nixpkgs (upstream archived) and disabled in
    # Homebrew on 2025-05-04, so it is no longer installable on a fresh Mac.
    # fastfetch is the recommended successor.
    # NOTE: ~/.config/neofetch/config.conf is not read by fastfetch (needs porting).
    fastfetch

    # editors / lsp
    pinnedNeovim     # neovim 0.11.2, pinned via nixpkgs-neovim in flake.nix
    lua-language-server
    luarocks

    # docs / media
    pandoc
    mpv
    pngpaste
    numbat

    # dev runtimes / tools
    uv

    # TeX for papers. Mirrors the collections currently installed under
    # /usr/local/texlive (scheme-small + the collections below, incl. Japanese).
    # Pinned by the flake, so this reproduces exactly across machines.
    (texliveSmall.withPackages (ps: with ps; [
      latexmk
      biber
      collection-langjapanese
      collection-langcjk
      collection-latexextra
      collection-latexrecommended
      collection-fontsrecommended
      collection-pictures
      collection-metapost
      collection-xetex
    ]))
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
    # Link only the rc files, NOT the whole zsh dir: ~/.config/zsh also holds
    # local runtime state (.zsh_history, .zsh_sessions, .zshrc.zwc) that must
    # stay out of the repo. This mirrors the current machine's setup.
    "zsh/.zprofile".source = link "${dotfiles}/zsh/.zprofile";
    "zsh/.zshenv".source = link "${dotfiles}/zsh/.zshenv";
    "zsh/.zshrc".source = link "${dotfiles}/zsh/.zshrc";
    "starship.toml".source = link "${dotfiles}/starship/starship.toml";
    # aerospace links only the toml file (matches current setup).
    "aerospace/aerospace.toml".source = link "${dotfiles}/aerospace/aerospace.toml";
  };

  # ~/.hammerspoon -> repo/.hammerspoon
  home.file.".hammerspoon".source = link "${dotfiles}/.hammerspoon";

  # Claude Code keeps runtime state, credentials, and conversation history in
  # ~/.claude too, so link only the portable, tracked configuration instead of
  # replacing the entire directory.
  home.file.".claude/CLAUDE.md".source =
    link "${dotfiles}/.claude/CLAUDE.md";
  home.file.".claude/settings.json".source =
    link "${dotfiles}/.claude/settings.json";
  home.file.".claude/statusline.sh".source =
    link "${dotfiles}/.claude/statusline.sh";
  home.file.".claude/skills/careful/SKILL.md".source =
    link "${dotfiles}/.claude/skills/careful/SKILL.md";

  # User-scoped MCP configuration lives in Claude's mutable ~/.claude.json,
  # alongside machine-local state. Add Codex idempotently rather than managing
  # that whole file declaratively.
  home.activation.configureClaudeIntegrations =
    config.lib.dag.entryAfter [ "writeBoundary" ] ''
      if command -v claude >/dev/null 2>&1 \
        && command -v codex >/dev/null 2>&1 \
        && ! claude mcp get codex >/dev/null 2>&1; then
        run claude mcp add --scope user --transport stdio codex -- codex mcp-server
      fi

      if command -v claude >/dev/null 2>&1 \
        && ! claude plugin list 2>/dev/null \
          | grep -Fq 'context7-plugin@context7-marketplace'; then
        run claude plugin install --scope user \
          context7-plugin@context7-marketplace
      fi
    '';

  # ---------------------------------------------------------------------------
  # Git and delta — reproduce the current ~/.gitconfig declaratively.
  # home-manager writes this to ~/.config/git/config.
  # ---------------------------------------------------------------------------
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "SNKK62";
        email = "koki.seno62@gmail.com";
      };
      core.editor = "vim";
      init.defaultBranch = "main";
      merge.tool = "vimdiff";
      mergetool.keepBackup = false;
      ghq.root = "${config.home.homeDirectory}/workspace";
      pager.reflog = "delta";
      alias = {
        diff-side-by-side = "-c delta.features=side-by-side diff";
        graph = "log --graph --date-order -C -M --pretty=format:\"<%h> %ad [%an] %Cgreen%d%Creset %s\" --all --date=short";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      plus-style = "syntax #012800";
      minus-style = "syntax #340001";
      syntax-theme = "zenburn";
      navigate = true;
      line-numbers = true;
      keep-plus-minus-markers = true;
    };
  };

  # Keep the legacy path as a direct link to the generated config. This makes
  # `git config --global` work too: that command does not expand includes unless
  # `--includes` is passed explicitly.
  home.file.".gitconfig" = {
    force = true;
    source = link "${config.xdg.configHome}/git/config";
  };

  # ---------------------------------------------------------------------------
  # Let home-manager manage itself.
  # ---------------------------------------------------------------------------
  programs.home-manager.enable = true;
}
