{ config, pkgs, ... }:

{
  services.udev.extraRules = ''SUBSYSTEM=="sgx", MODE="0666"'';

  boot.kernelPackages = let
      linux_sgx_pkg = { stdenv, fetchurl, buildLinux, ... } @ args:

        with stdenv.lib;

        buildLinux (args // rec {
          version = "5.4.0-rc3";
          modDirVersion = "5.4.0-rc3";

          src = fetchurl {
            url = "https://github.com/jsakkine-intel/linux-sgx/archive/v23.tar.gz";
            sha256 = "11rwlwv7s071ia889dk1dgrxprxiwgi7djhg47vi56dj81jgib20";
          };
          kernelPatches = [];

          extraConfig = ''
            INTEL_SGX y
          '';

          extraMeta.branch = "5.4";
        } // (args.argsOverride or {}));
      linux_sgx = pkgs.callPackage linux_sgx_pkg{};
    in
      pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor linux_sgx);
}


