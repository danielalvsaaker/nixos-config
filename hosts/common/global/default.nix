{ pkgs, ... }:
{
  imports = [
    ./fish.nix
  ];

  fonts = {
    enableDefaultPackages = true;
    fontconfig.defaultFonts = {
      monospace = [ "BlexMono Nerd Font Mono" ];
    };

    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "IBMPlexMono" ]; })
    ];
  };

  time.timeZone = "Europe/Oslo";

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  console.useXkbConfig = true;
  system.stateVersion = "22.11";

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
}
