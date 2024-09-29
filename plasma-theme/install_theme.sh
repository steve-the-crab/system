#! /bin/sh

script_dir = $(dirname "$0")

mkdir -p ~/.local/share/plasma/desktoptheme/Theme

cp -r $script_dir ~/.local/share/plasma/desktoptheme/
