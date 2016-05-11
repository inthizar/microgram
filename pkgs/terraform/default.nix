# Lifted almost verbatim from
# https://github.com/NixOS/nixpkgs/blob/a2612dc0f13eb995ed3c491b96c119e2de892248/pkgs/top-level/go-packages.nix

{ goPackages }:
let

  inherit (goPackages) buildFromGitHub go;

  isGo14 = go.meta.branch == "1.4";
  isGo15 = go.meta.branch == "1.5";

  terraform = buildFromGitHub {
    rev = "v0.6.15";
    owner = "hashicorp";
    repo = "terraform";
    disabled = isGo14 || isGo15;
    sha256 = "1mf98hagb0yp40g2mbar7aw7hmpq01clnil6y9khvykrb33vy0nb";

    postInstall = ''
      # prefix all the plugins with "terraform-"
      for i in $bin/bin/*; do
        if [[ ! $(basename $i) =~ terraform* ]]; then
          mv -v $i $bin/bin/terraform-$(basename $i);
        fi
      done
    '';
  };

in terraform
