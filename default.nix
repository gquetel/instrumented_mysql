let 
  pkgs = import (
    builtins.fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/f85a2d005e83542784a755ca8da112f4f65c4aa4.tar.gz";
      sha256 = "sha256:0xajxa96hz8rgpwj2sm16i89m1kf48hqwf2m7p2m8lbbjdigjw2v";
    }
  ) {};
  lib = pkgs.lib ;

  fs = lib.fileset ;
  sourceFiles = ./bison/skeletons ; 
  src_grammars = fs.toSource {
    root = ./.;
    fileset = sourceFiles;
  };

 
  custom-bison = pkgs.bison.overrideAttrs(p: final: {
    postInstall = ''
    cp -vrT ${./bison/skeletons} $out/share/bison/skeletons/
  '';
    doInstallCheck = false; # Disabled tests, they are too long when debuging

  }); 
in
(pkgs.mysql84.overrideAttrs (final: prev: {
patches = prev.patches ++ [ ./mysql/sql_yacc.patch];
})).override({bison =custom-bison;})