# This version is used for bypass microsoft

(final: prev: {
  prismlauncher = prev.prismlauncher.overrideAttrs (oldAttrs: rec {
    version = "9.4";

    src = prev.fetchFromGitHub {
      owner = "PrismLauncher";
      repo = "PrismLauncher";
      rev = version;
      # Prism Launcher requires submodules to build successfully
      fetchSubmodules = true; 
      # Using a placeholder hash; Nix will complain and give you the correct one on rebuild
      hash = "sha256-Ndt0op00byJL2Xk2oJIMEwu8uVv0PTL9mHDk8kH3r/c=";
    };
  });
})
