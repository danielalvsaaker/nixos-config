{ lib, ... }:
{
  flake.lib.modules = (import ./modules.nix) { inherit lib; };
}
