{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  boot.loader.grub.device = "/dev/vda";
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = { device = "/dev/vda1"; fsType = "ext4"; };
  swapDevices = 
    [ { device = "/dev/disk/by-uuid/0ea10684-5722-4a8a-822f-e23c79aa60b9"; }
    ];

    # Enable Zram
  zramSwap = {
    enable = true;
    priority = 5; 
    swapDevices = 1;
    memoryPercent = 50;
  };

}
