{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, modDirVersionArg ? null, ... } @ args:

with lib;

buildLinux (args // rec {
  version = "4.19.221";

  # modDirVersion needs to be x.y.z, will automatically add .0 if needed
  modDirVersion = if (modDirVersionArg == null) then concatStringsSep "." (take 3 (splitVersion "${version}.0")) else modDirVersionArg;

  # branchVersion needs to be x.y
  extraMeta.branch = versions.majorMinor version;

  src = fetchurl {
    url = "mirror://kernel/linux/kernel/v4.x/linux-${version}.tar.xz";
    sha256 = "1yg1cibyn53gpjnxfgj2qxxi8k3l7gv1ri6kywvp6sk5bygx8jd3";
  };

  kernelTests = args.kernelTests or [ nixosTests.kernel-generic.linux_4_19 ];
} // (args.argsOverride or {}))
