{
  description = "Harro's nixos and home-manager config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin = {
      url = "github:catppuccin/nix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets = {
      url = "git+ssh://git@github.com/Harro3/nix-secrets.git?ref=main&shallow=1";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    inherit (self) outputs;
    inherit (nixpkgs) lib;

    libharro = import ./lib {inherit lib;};

    mkHost = host: {
      ${host} = lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit inputs outputs libharro;
          vars = {
            hostname = host;
            mainUser = "harro";
          };
        };

        modules = [
          ./hosts/nixos/${host}
        ];
      };
    };

    hosts = lib.attrNames (builtins.readDir ./hosts/nixos);

    nixosConfigurations = lib.foldl (acc: set: acc // set) {} (lib.map (host: mkHost host) hosts);

    mkHome = user: host: {
      "${user}@${host}" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {inherit system;};
        modules = [./home/${user}/${host}.nix];

        extraSpecialArgs = {
          inherit inputs outputs libharro;
          vars = {
            system = system;
            mainUser = "harro";
            hostname = host;
            username = user;
          };
        };
      };
    };

    mkHomes = user: let
      hostFiles = builtins.attrNames (lib.attrsets.filterAttrs (path: _type: (_type != "directory")) (builtins.readDir ./home/${user}));

      hostnames = builtins.map (f: lib.removeSuffix ".nix" f) hostFiles;
    in
      lib.foldl (acc: set: acc // set) {} (lib.map (host: mkHome user host) hostnames);

    users = lib.attrNames (builtins.readDir ./home);

    homeConfigurations = lib.foldl (acc: set: acc // set) {} (lib.map (user: mkHomes user) users);
  in {
    inherit nixosConfigurations homeConfigurations;
  };
}
