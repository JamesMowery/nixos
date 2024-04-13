{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" "i2c-dev" "i2c-piix4" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [ "pcie_port_pm=off" "pcie_aspm.policy=performance" "acpi_enforce_resources=lax" ];

  fileSystems."/" =
    #{ device = "/dev/disk/by-uuid/9f490704-1542-4593-b0d3-f295ad8592f4";
    { device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd" "space_cache=v2" "noatime" ];
    };

  fileSystems."/home" =
    #{ device = "/dev/disk/by-uuid/9f490704-1542-4593-b0d3-f295ad8592f4";
    { device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" "space_cache=v2" "noatime" ];
    };

  fileSystems."/nix" =
    #{ device = "/dev/disk/by-uuid/9f490704-1542-4593-b0d3-f295ad8592f4";
    { device = "/dev/disk/by-label/nixos";
      fsType = "btrfs";
      options = [ "subvol=@nix" "compress=zstd" "space_cache=v2" "noatime" ];
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/E475-AC97";
      fsType = "vfat";
    };

    fileSystems."/mnt/games" =
    { device = "/dev/disk/by-uuid/6b09080b-4ff2-4655-878b-feb9a5b8e5be";
      fsType = "btrfs";
      options = [ "subvol=@games" "compress=zstd" "space_cache=v2" "noatime" ];
    };
  
  fileSystems."/mnt/data" =
    { device = "/dev/disk/by-uuid/6b09080b-4ff2-4655-878b-feb9a5b8e5be";
      fsType = "btrfs";
      options = [ "subvol=@data" "compress=zstd" "space_cache=v2" "noatime" ];
    };
  
  fileSystems."/mnt/backup" =
    { device = "/dev/disk/by-uuid/6b09080b-4ff2-4655-878b-feb9a5b8e5be";
      fsType = "btrfs";
      options = [ "subvol=@backup" "compress=zstd" "space_cache=v2" "noatime" ];
    };

  swapDevices = [ ];

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" ];
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp9s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
