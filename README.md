# Instrumented MySQL

## Building instrumented MySQL

```
 nix-build -E 'let pkgs = import <nixpkgs> { }; in pkgs.callPackage ./package.nix {}'
```

## Building instrumented Bison

## TODO: 

- ~~Ajouter le patch de grammaire MySQL.~~
- ~~Modifier package bison pour y inclure le fichier squelette modifié. -> voir https://nix.dev/tutorials/working-with-local-files.html.~~ 
- Puis indiquer à MySQL de dépendre de ce package modifié. -> voir https://nixos.wiki/wiki/Overlays#Overriding_a_version
- Ajouter script qui, une fois mysql compilé, initialise le serveur, change le mot de passe root en retrouvant celui de la console (peut peut-être se faire via options ou variables d'environnement ?), puis initilise le compte utilisateur, la base de données et la table pour les XPs.
  - voir-> https://discourse.nixos.org/t/is-there-a-way-to-run-mysql-via-nixpkgs-on-non-nixos-distros-like-ubuntu/9767/7
- Tout mettre dans un docker ?