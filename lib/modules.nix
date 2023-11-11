{ lib, ... }:
{
  generateModules = path:
    let
      recurse = segments:
        let
          dir = builtins.concatStringsSep "/" ([ path ] ++ segments);
          stat = builtins.readDir dir;
          f = acc: name:
            if stat.${name} == "directory" then
              acc // recurse (segments ++ [ name ])
            else if name == "default.nix" && segments != [ ] then
              acc // {
                "${builtins.concatStringsSep "-" segments}" = dir;
              }
            else if lib.hasSuffix ".nix" name then
              acc // {
                "${builtins.concatStringsSep "-" (segments ++ [ (lib.removeSuffix ".nix" name) ])}" = (dir + "/" + name);
              }
            else
              acc;
        in
        builtins.foldl' f { } (builtins.attrNames stat);
    in
    recurse [ ];
}
