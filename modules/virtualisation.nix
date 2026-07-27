# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
args@{ ... }:
{
  programs = {
    virt-manager.enable = true;
  };
  users.groups.libvirtd = { };
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
}
