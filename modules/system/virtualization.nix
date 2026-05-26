{
  config,
  lib,
  pkgs,
  hostVariables,
  ...
}: {
  options.modules.system.virtualization = {
    enable = lib.mkEnableOption "KVM/libvirt virtualization";
  };

  config = lib.mkIf config.modules.system.virtualization.enable {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
      };
    };

    programs.virt-manager.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;

    users.users.${hostVariables.username}.extraGroups = [
      "kvm"
      "libvirtd"
    ];

    environment = {
      etc = {
        "libvirt/windows/virtio-win.iso".source = pkgs.virtio-win.src;
        "libvirt/windows/win-spice".source = pkgs.win-spice;
      };

      systemPackages = with pkgs; [
        virt-viewer
      ];
    };
  };
}
