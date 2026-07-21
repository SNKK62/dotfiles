{
  description = "kokiseno's macOS system, faithfully reproduced with nix-darwin + home-manager";

  inputs = {
    # Track a recent nixpkgs. Pin/upgrade with `nix flake update`.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Pinned nixpkgs that still ships neovim 0.11.2. Kept separate from the main
    # nixpkgs (which has moved to 0.12.x) so we can reproduce exactly 0.11.2.
    # To bump neovim, point this at a newer commit (see nixhub.io/packages/neovim).
    nixpkgs-neovim.url = "github:NixOS/nixpkgs/a421ac6595024edcfbb1ef950a3712b89161c359";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, nixpkgs-neovim, nix-darwin, home-manager, ... }:
    let
      # ----------------------------------------------------------------------
      # Machine identity. Change `hostname` if this Mac's Local Host Name
      # differs (System Settings > General > Sharing > Local hostname), then
      # rebuild with `darwin-rebuild switch --flake .#<hostname>`.
      # ----------------------------------------------------------------------
      hostname = "koki-mac";
      username = "kokiseno";
      system = "aarch64-darwin"; # Apple Silicon (arm64)

      # neovim 0.11.2 from the pinned nixpkgs above (main nixpkgs has 0.12.x).
      pinnedNeovim = (import nixpkgs-neovim { inherit system; }).neovim;
    in
    {
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit username hostname; };
        modules = [
          ./darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit username pinnedNeovim; };
            home-manager.users.${username} = import ./home.nix;
          }
        ];
      };

      # Convenience alias so `darwin-rebuild switch --flake .#mac` also works.
      darwinConfigurations.mac = self.darwinConfigurations.${hostname};
    };
}
