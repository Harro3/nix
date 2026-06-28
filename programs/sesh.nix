{
  perSystem =
    { pkgs, ... }:
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
      packages.sesh = {
        type = "app";
        program = "${pkgs.writeShellScript "sesh-wrapper" ''
          exec ${pkgs.sesh}/bin/sesh -c ${config} "$@"
        ''}";
      };
    };
}
