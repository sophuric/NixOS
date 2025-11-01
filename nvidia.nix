# vim: fixeol eol expandtab tabstop=2 shiftwidth=2
{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfreePredicate =
    let ensureList = x: if builtins.isList x then x else [ x ];
    in pkg:
    builtins.elem (lib.getName pkg) [ "nvidia-x11" ] || builtins.all (license:
      license.free || builtins.elem license.shortName [
        "CUDA EULA"
        "cuDNN EULA"
        "cuSPARSELt EULA"
        "cuTENSOR EULA"
        "NVidia OptiX EULA"
      ]) (ensureList pkg.meta.license);
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
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  environment.systemPackages = [ pkgs.nvtopPackages.nvidia ];
}
