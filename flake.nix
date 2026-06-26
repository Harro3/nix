{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    wrappers.url = "github:Lassulus/wrappers";
    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim.url = "github:nix-community/nixvim";

    sops-nix.url = "github:mic92/sops-nix";
    secrets = {
      url = "git+ssh://git@github.com/Harro3/nix-secrets.git?ref=main&shallow=1";
      flake = false;
    };
  };
  outputs =
    inputs:
    let
      lib = inputs.nixpkgs.lib;

      importTree =
        dir:
        let
          readDirRecursive =
            path:
            let
              entries = builtins.readDir path;
            in
            lib.concatLists (
              lib.mapAttrsToList (
                name: type:
                let
                  full = path + "/${name}";
                in
                if type == "directory" then
                  if lib.hasPrefix "_" name then [ ] else readDirRecursive full
                else if lib.hasSuffix ".nix" name && name != "flake.nix" then
                  [ full ]
                else
                  [ ]
              ) entries
            );
        in
        readDirRecursive dir;

      mkModules = dir: lib.map (p: import p) (importTree dir);
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = mkModules ./.;
    };
}
