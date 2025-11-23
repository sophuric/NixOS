# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ config, pkgs, util, ... }: {
  allowUnfreePackages = [
    "nvidia-x11"
    (pkg:
      builtins.all (license: license.free) (util.ensureList pkg.meta.license)
      || pkgs._cuda.lib.allowUnfreeCudaPredicate pkg)
  ];
  services.xserver.videoDrivers = [ "nvidia" ];
  boot.blacklistedKernelModules = [ "nouveau" "amdgpu" ];
  boot.kernelModules = [ "nvidia" ];
  boot.kernelParams = [ "nvidia_drm.modeset=1" "nvidia_drm.fbdev=1" ];
  environment.variables = {
    LIBVA_DRIVER_NAME = "nvidia";
    VDPAU_DRIVER = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  environment.systemPackages = [ pkgs.nvtopPackages.nvidia ];
}
