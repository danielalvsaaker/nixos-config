{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    falcon-sensor-nixos = {
      url = "git+ssh://git@github.com/bouvet/falcon-sensor-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };

    bcachefs-tools = {
      url = "github:koverstreet/bcachefs-tools";
    };
  };

  outputs = { flake-parts, ... } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem = { pkgs, inputs', system, ... }: {
        formatter = pkgs.nixpkgs-fmt;

        packages.qemu-efi = pkgs.writeShellScriptBin "qemu-efi" ''
          qemu-system-x86_64 \
            -m 2048 \
            -machine q35,accel=kvm \
            -bios "${pkgs.OVMF.fd}/FV/OVMF.fd" \
            -snapshot \
            -serial stdio \
            "$@"
        '';
      };

      imports = [
        ./lib
        ./hosts
        ./home
        ./modules
      ];
    };
}
