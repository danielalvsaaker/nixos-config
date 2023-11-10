{ lib, ... }:

let
  inherit (builtins) filter map toString listToAttrs;
  inherit (lib) removeSuffix nameValuePair hasSuffix concatStringsSep removePrefix;
  inherit (lib.filesystem) listFilesRecursive pathIsDirectory;
  inherit (lib.attrsets) filterAttrs;

  stripNixSuffix = path: removeSuffix ".nix" (removeSuffix "/default.nix" path);
  cleanPathParts = path: filter (p: p != "") (lib.splitString "/" path);
  makeModuleName = basePath: path:
    let
      relativePath = removePrefix (toString basePath + "/") (toString path);
    in
    concatStringsSep "-" (cleanPathParts (stripNixSuffix relativePath));
in
{
  generateModules = basePath:
    let
      filterNixFilesAndDirs = path: hasSuffix ".nix" (toString path) ||
        (pathIsDirectory path && builtins.pathExists (toString path + "/default.nix"));
      allNixFilesAndDirs = filter filterNixFilesAndDirs (listFilesRecursive basePath);
      makeModulePair = path: nameValuePair (makeModuleName basePath path) (import path);
    in
    listToAttrs (filter ({ name, value }: name != "default") (map makeModulePair allNixFilesAndDirs));
}
