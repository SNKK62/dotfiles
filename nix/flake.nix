{
  description = "kokiseno's macOS system, faithfully reproduced with nix-darwin + home-manager";

  inputs = {
    # Track a recent nixpkgs. Pin/upgrade with `nix flake update`.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

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
    { self, nixpkgs, nix-darwin, home-manager, ... }:
    let
      # ----------------------------------------------------------------------
      # Machine identity. Change `hostname` if this Mac's Local Host Name
      # differs (System Settings > General > Sharing > Local hostname), then
      # rebuild with `darwin-rebuild switch --flake .#<hostname>`.
      # ----------------------------------------------------------------------
      hostname = "koki-mac";
      username = "kokiseno";
      system = "aarch64-darwin"; # Apple Silicon (arm64)
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
            home-manager.extraSpecialArgs = { inherit username; };
            home-manager.users.${username} = import ./home.nix;
          }
        ];
      };

      # Convenience alias so `darwin-rebuild switch --flake .#mac` also works.
      darwinConfigurations.mac = self.darwinConfigurations.${hostname};
    };
}
