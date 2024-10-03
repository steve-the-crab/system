#! /bin/sh

cd ~

nix-env -iA nixpkgs.git

git pull https://github.com/steve-the-crab/system

cd system

