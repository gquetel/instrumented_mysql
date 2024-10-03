# Instrumented MySQL

## Building instrumented MySQL

```
 nix-build -E 'let pkgs = import <nixpkgs> { }; in pkgs.callPackage ./package.nix {}'
```

## Building instrumented Bison

## TODO: 

- ~~Ajouter le patch de grammaire MySQL.~~
- Modifier package bison pour y inclure le fichier squelette modifié. Puis indiquer à MySQL de dépendre de ce package modifié.
- Ajouter script qui, une fois mysql compilé, initialise le serveur, change le mot de passe root en retrouvant celui de la console (peut peut-être se faire via options ou variables d'environnement ?), puis initilise le compte utilisateur, la base de données et la table pour les XPs.
- Tout mettre dans un docker ?