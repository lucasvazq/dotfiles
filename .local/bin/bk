#!/bin/sh


# Change background image and set color scheme
# Args:
#   $1 (optional): Wallpaper. If not provided, a one random is selected from
#     ~/Pictures/Wallpapers


if [ ! -z "$1" ]; then
    WALLPAPER=$1
else
    WALLPAPERS=(~/Pictures/Wallpapers/*)
    WALLPAPER=${WALLPAPERS[RANDOM % ${#WALLPAPERS[@]}]}
fi

# Change wallpaper
nitrogen --set-scaled $WALLPAPER

# Change polybar and terminal colors
wal -i $WALLPAPER

# Change dunst color
ln -sf ${HOME}/.cache/wal/dunstrc ${HOME}/.config/dunst/dunstrc
pkill dunst
dunst &
