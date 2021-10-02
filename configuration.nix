{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./network.nix
    ./nginx.nix   
  ];

  boot.cleanTmpDir = true;

  # Define a user account. Don't forget to set a password with ‘passwd’
  users.users.leznom = {
    isNormalUser = true;
    home = "/home/leznom";
    description = "Pusch Angel";
    extraGroups = [ "wheel" ];
  };

  # Sudo without requiring password
  security.sudo.wheelNeedsPassword = false;

  # Clean up packages after a while
  nix.gc = {
    automatic = true;
    dates = "weekly UTC";
  };

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    gitMinimal
  ];
}
