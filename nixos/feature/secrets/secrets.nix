{inputs, self, ...}: {
  flake.nixosModules.secrets = {pkgs, config, ...}: let
    user = config.preferences.user.name;
    secretspath = "${builtins.toString inputs.secrets}/secrets.yaml";
    homeDirectory = "/home/${user}";
    in {
    imports = [
	inputs.sops-nix.nixosModules.sops
   ];

    config = {
    environment.systemPackages = with pkgs; [
	sops
    ];

    sops = {
	defaultSopsFile = secretspath;
	validateSopsFiles = false;

	age = {
	  keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
	};

	secrets = {
	  "yubico/u2f_keys" = {
	    owner = user;
	    inherit (config.users.users.${user}) group;
	    path = "${homeDirectory}/.config/Yubico/u2f_keys";
	  };

	  harro-password.neededForUsers = true;

	  "private_keys/harro" = {
	    path = "${homeDirectory}/.ssh/id_25519";
	  };
	};
    };

    systemd.tmpfiles.rules = [
      "L+ ${homeDirectory}/.ssh/id_ed25519.pub - - - - ${./id_ed25519.pub}"
    ];

    users.users.${user}.hashedPasswordFile = config.sops.secrets.harro-password.path;
  };
};
}
