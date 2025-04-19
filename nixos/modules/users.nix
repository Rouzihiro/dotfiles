{
  inputs,
  username,
  hostname,
	gitUsername, 
	gitEmail,
  ...
}: {
  imports = [inputs.home-manager.nixosModules.home-manager];

  users.users.${username} = {
    isNormalUser = true;
    description = "${username}";
    extraGroups = ["networkmanager" "wheel" "input" "render" "video" "audio" "bluetooth" "kvm"];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit inputs username hostname gitUsername gitEmail;};

    users.${username} = {
      imports = [(../../home + "/home-${hostname}.nix")];
      fonts.fontconfig.enable = true;
      programs.home-manager.enable = true;
      home = {
        stateVersion = "25.05";
        username = "${username}";
        homeDirectory = "/home/${username}";
      };
    };
  };
}
