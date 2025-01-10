let 
  inputs = import ./npins; 
  pkgs =  import inputs.nixpkgs { };
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
patches = prev.patches ++ [./mysql/sql_yacc.patch];
})).override({bison =custom-bison;})