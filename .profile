#!/bin/sh


export QT_QPA_PLATFORMTHEME="qt5ct"
export EDITOR=/usr/bin/nvim
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export BROWSER=/usr/bin/brave
export DEFAULT_NETWORK_INTERFACE=$(ip route | grep '^default' | awk '{print $5}' | head -n1)
