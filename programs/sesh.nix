{
  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    let
      config = pkgs.writeText "sesh.toml" ''
        [default_session]
        startup_command = 'nvim'

        [[session]]
        name='Downloads '
        path='~/Downloads'
        startup_command='ls'

        [[session]]
        name='Vim Config '
        path='~/nix/home/harro/common/core/nixvim'

        [[session]]
        name='Nix Config '
        path='~/nix'
      '';
    in
    {
      packages.sesh = pkgs.writeShellApplication {
        name = "sesh";
        runtimeInputs = [ pkgs.sesh ];
        text = ''
          exec ${lib.getExe pkgs.sesh} -C ${config} "$@"
        '';
      };
    };
}
