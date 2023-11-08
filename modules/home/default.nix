{
  flake.homeManagerModules = {
    program-discord = { imports = [ ./programs/discord.nix ]; };
    program-foot = { imports = [ ./programs/foot.nix ]; };
    program-firefox = { imports = [ ./programs/firefox.nix ]; };
    program-element = { imports = [ ./programs/element.nix ]; };
    program-sway = { imports = [ ./programs/sway ]; };
  };
}
