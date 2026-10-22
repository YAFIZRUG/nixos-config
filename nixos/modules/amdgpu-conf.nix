{pkgs, ...}: {
  # Whether to enable loading amdgpu kernelModule in stage 1. Can fix lower resolution in boot screen during initramfs phase.
  # hardware.amdgpu.initrd.enable = true;

  # Явное включение графики OpenGl и Vulcan
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Для некоторых старых и wine-приложений
  };
}
