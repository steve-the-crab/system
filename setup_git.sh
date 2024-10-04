#! /bin/sh

cd ~

nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
nix-channel --update

nix-env -iA nixpkgs.git

git pull https://github.com/steve-the-crab/system

cd system

