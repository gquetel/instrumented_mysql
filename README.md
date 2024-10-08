# Instrumented MySQL

## Building instrumented MySQL

```
 nix-build -E 'let pkgs = import <nixpkgs> { }; in pkgs.callPackage ./package.nix {}'
```

###### Init db script
- Option `--log-error` nécessaire sur les machines de calcul car sinon mysql prend la configuration du /etc/mysql/...cnf qui lui dit d'aller écrire dans une fichier auquel il n'a pas accès et cela fait planter l'initialisation. Ainsi par défaut les logs d'erreurs seront imprimés dans `datadir/hostname.err`.
- Option `--port 61337` (port aléatoire) est apparement nécessaire pour lancer le serveur. Même si l'on utilise un socket, il lui faut un port valide, or un mysql tourne déjà sur les machines, on en fourni un aléatoire.
  
## Building instrumented Bison

## TODO: 

- ~~Ajouter le patch de grammaire MySQL.~~
- ~~Modifier package bison pour y inclure le fichier squelette modifié. -> voir https://nix.dev/tutorials/working-with-local-files.html.~~ 
- Puis indiquer à MySQL de dépendre de ce package modifié. -> voir https://nixos.wiki/wiki/Overlays#Overriding_a_version
- ~~Ajouter script qui, une fois mysql compilé, initialise le serveur~~   voir-> https://discourse.nixos.org/t/is-there-a-way-to-run-mysql-via-nixpkgs-on-non-nixos-distros-like-ubuntu/9767/7
- Script SQL qui initialise le compte utilisateur, la base de données et la table pour les XPs.
- Tout mettre dans un docker ?

- Pour que le connector python se connecte via socket, utiliser le fichier de config, argument unix_socket à la fonction mysql.connector.connect() avec la même valeur que SOCKET_PATH.