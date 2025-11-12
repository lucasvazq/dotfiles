#!/usr/bin/env bash
set -euo pipefail

function main {
    _presentation

    local password
    password="$(_get_password)"

    _setup_configuration_files
    _configure_yay "${password}"
    _install_drivers "${password}"
    _install_packages "${password}"
    _configure_dns "${password}"
    _setup_crontab
    _post_installation_cleanup

    echo ""
    echo "Post installation: Look at the README.md for next steps!"
}

function _presentation {
    function _show_frame_lines() {
        local frames
        frames=("$@")
        clear
        echo ""
        echo -e "${frames[@]}"
        echo ""
        sleep 0.075
    }

    local main_color reflect reset
    main_color="\e[96m"
    reflect="\e[97m"
    reset="\e[0m"

    local frame_logo \
        frame_reflect_1 frame_reflect_2 frame_reflect_3 frame_reflect_4 frame_reflect_5 frame_reflect_6
    frame_logo=(
        " ${main_color}██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗\n"
        "${main_color}██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝\n"
        "${main_color}██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗\n"
        "${main_color}██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║\n"
        "${main_color}██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║\n"
        "${main_color}╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝\n"
    )
    frame_reflect_1=(
        " ${reflect}███${main_color}███╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗███████╗\n"
        "${reflect}██${main_color}╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝\n"
        "${reflect}█${main_color}█║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ███████╗\n"
        "${main_color}██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║\n"
        "${main_color}██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗███████║\n"
        "${main_color}╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝\n"
    )
    frame_reflect_2=(
        " ${main_color}██████╗  ${reflect}██████${main_color}╗ ████████╗███████╗██╗██╗     ███████╗███████╗\n"
        "${main_color}██╔══██╗${reflect}██╔═══${main_color}██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔════╝\n"
        "${main_color}██║  ██${reflect}║██║  ${main_color} ██║   ██║   █████╗  ██║██║     █████╗  ███████╗\n"
        "${main_color}██║  █${reflect}█║██║ ${main_color}  ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚════██║\n"
        "${main_color}█████${reflect}█╔╝╚██${main_color}████╔╝   ██║   ██║     ██║███████╗███████╗███████║\n"
        "${main_color}╚═══${reflect}══╝  ╚${main_color}═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝\n"
    )
    frame_reflect_3=(
        " ${main_color}██████╗  ██████╗ ████${reflect}████╗█${main_color}██████╗██╗██╗     ███████╗███████╗\n"
        "${main_color}██╔══██╗██╔═══██╗╚══${reflect}██╔══╝${main_color}██╔════╝██║██║     ██╔════╝██╔════╝\n"
        "${main_color}██║  ██║██║   ██║  ${reflect} ██║  ${main_color} █████╗  ██║██║     █████╗  ███████╗\n"
        "${main_color}██║  ██║██║   ██║ ${reflect}  ██║ ${main_color}  ██╔══╝  ██║██║     ██╔══╝  ╚════██║\n"
        "${main_color}██████╔╝╚██████╔╝${reflect}   ██║${main_color}   ██║     ██║███████╗███████╗███████║\n"
        "${main_color}╚═════╝  ╚═════╝${reflect}    ╚═${main_color}╝   ╚═╝     ╚═╝╚══════╝╚══════╝╚══════╝\n"
    )
    frame_reflect_4=(
        " ${main_color}██████╗  ██████╗ ████████╗███████${reflect}╗██╗██${main_color}╗     ███████╗███████╗\n"
        "${main_color}██╔══██╗██╔═══██╗╚══██╔══╝██╔═══${reflect}═╝██║█${main_color}█║     ██╔════╝██╔════╝\n"
        "${main_color}██║  ██║██║   ██║   ██║   █████${reflect}╗  ██║${main_color}██║     █████╗  ███████╗\n"
        "${main_color}██║  ██║██║   ██║   ██║   ██╔═${reflect}═╝  ██${main_color}║██║     ██╔══╝  ╚════██║\n"
        "${main_color}██████╔╝╚██████╔╝   ██║   ██║${reflect}     █${main_color}█║███████╗███████╗███████║\n"
        "${main_color}╚═════╝  ╚═════╝    ╚═╝   ╚═${reflect}╝     ${main_color}╚═╝╚══════╝╚══════╝╚══════╝\n"
    )
    frame_reflect_5=(
        " ${main_color}██████╗  ██████╗ ████████╗███████╗██╗██╗     ${reflect}██████${main_color}█╗███████╗\n"
        "${main_color}██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║    ${reflect} ██╔══${main_color}══╝██╔════╝\n"
        "${main_color}██║  ██║██║   ██║   ██║   █████╗  ██║██║   ${reflect}  ████${main_color}█╗  ███████╗\n"
        "${main_color}██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║  ${reflect}   ██╔${main_color}══╝  ╚════██║\n"
        "${main_color}██████╔╝╚██████╔╝   ██║   ██║     ██║████${reflect}███╗██${main_color}█████╗███████║\n"
        "${main_color}╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══${reflect}════╝╚${main_color}══════╝╚══════╝\n"
    )
    frame_reflect_6=(
        " ${main_color}██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗████${reflect}███╗\n"
        "${main_color}██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝██╔${reflect}════╝\n"
        "${main_color}██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗  ██${reflect}█████╗\n"
        "${main_color}██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝  ╚${reflect}════██${main_color}║\n"
        "${main_color}██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗${reflect}██████${main_color}█║\n"
        "${main_color}╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════${reflect}╝╚════${main_color}══╝\n"
    )

    _show_frame_lines "${frame_logo[@]}"
    _show_frame_lines "${frame_reflect_1[@]}"
    _show_frame_lines "${frame_reflect_2[@]}"
    _show_frame_lines "${frame_reflect_3[@]}"
    _show_frame_lines "${frame_reflect_4[@]}"
    _show_frame_lines "${frame_reflect_5[@]}"
    _show_frame_lines "${frame_reflect_6[@]}"
    _show_frame_lines "${frame_logo[@]}"
    echo -e "${reset}"
}

function _get_password {
    # Ask for password and save it to don't ask for it again while the installation.
    local correct_password password
    correct_password=false
    until [ "${correct_password}" == true ]; do
        echo -n "Password: "
        IFS= read -rs password
        if echo "${password}" | sudo -S -k -v &> /dev/null; then
            correct_password=true
        else
            echo -e "\nWrong password"
        fi
    done
    echo "${password}"
}

function _setup_configuration_files {
    git clone https://github.com/lucasvazq/dotfiles.git "${HOME}/dotfiles"
    rsync -a "${HOME}/dotfiles/" "${HOME}/"

    chmod 711 "${HOME}/.local/bin/change-background"
    chmod 711 "${HOME}/.local/bin/custom-scrot"
    chmod 711 "${HOME}/.local/bin/picture-of-the-day"
    mkdir -p "${HOME}/Pictures"/{Wallpapers,Screenshots}
    mkdir -p "${HOME}/Workspaces"
}

function _configure_yay {
    local password
    password="$1"

    echo "${password}" | sudo -S -k eos-rankmirrors
    yes | yay --save --answerclean None --answerdiff None --answeredit None --noremovemake --sudoloop
    yes | \
        # Roses are red
        # violets are blue
        # I have Endeavour i3
        yay -Syu
}

function _install_drivers {
    local password
    password="$1"

    # GPU Drivers.
    local gpu_info
    gpu_info="$(lspci | grep -E "VGA|3D")"
    if echo "${gpu_info}" | grep -qi "NVIDIA"; then
        yes | yay -S nvidia-inst
        echo "${password}" | sudo -S -k nvidia-inst
    elif echo "${gpu_info}" | grep -qi "AMD"; then
        yes | yay -S mesa vulkan-radeon lib32-vulkan-radeon
    elif echo "${gpu_info}" | grep -qi "Intel"; then
        yes | yay -S mesa vulkan-intel lib32-vulkan-intel
    else
        yes | yay -S mesa vulkan-swrast lib32-vulkan-swrast
    fi
}

function _install_packages {
    local password
    password="$1"

    # Utilities & Required by system.
    yes | yay -S trash-cli
    yes | yay -S gnome-keyring
    yes | yay -S slop python-pywal qt5ct
    yes | yay -S ttf-jetbrains-mono-nerd noto-fonts-emoji

    # Shell.
    yes | yay -S zsh starship
    echo "${password}" | chsh -s "$(command -v zsh)"

    # Apps.
    yes | yay -S google-chrome
    yes | yay -S visual-studio-code-bin warp-terminal-bin
    yes | yay -S libreoffice-fresh
    yes | yay -S gimp shotcut
    yes | yay -S neohtop
    yes | yay -S steam

    # GitHub & Git.
    yes | yay -S github-cli
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    git config --global core.excludesfile "${HOME}/.config/git/gitignore"

    # Docker.
    yes | yay -S docker-desktop
    echo "${password}" | sudo -S -k usermod -aG docker "${USER}"
    echo "${password}" | sudo -S -k rm -f /etc/firewalld/policies/docker*
    echo "${password}" | sudo -S -k rm -f /etc/firewalld/zones/docker*
    echo "${password}" | sudo -S -k firewall-cmd --permanent --delete-zone=docker || true
    echo "${password}" | sudo -S -k firewall-cmd --permanent --delete-zone=docker-forwarding || true
    echo "${password}" | sudo -S -k firewall-cmd --reload
    echo "${password}" | sudo -S -k systemctl enable docker

    # Python.
    yes | yay -S python-pip
    python -m venv "${HOME}/.config/.venv"

    # JavaScript.
    yes | yay -S nvm
    source /usr/share/nvm/init-nvm.sh
    nvm install node
}

function _configure_dns {
    local password
    password="$1"

    { printf "%s\n" "${password}"; printf "nameserver 8.8.8.8\nnameserver 8.8.4.4\n"; } \
        | sudo -S -k tee /etc/resolv.conf > /dev/null
    { printf "%s\n" "${password}"; printf "[main]\ndns=none\n"; } \
        | sudo -S -k tee /etc/NetworkManager/NetworkManager.conf > /dev/null
}

function _setup_crontab {
    local job current
    job="00 00 * * * ${HOME}/.local/bin/picture-of-the-day"
    current="$(crontab -l 2>/dev/null || true)"
    if ! grep -Fqx -- "${job}" <<< "${current}"; then
        ( printf "%s\n" "${current}"; printf "%s\n" "${job}" ) | crontab -
    fi
}

function _post_installation_cleanup {
    # Merge some default folders into the Downloads folder.
    xdg-user-dirs-update --set XDG_DESKTOP_DIR "${HOME}/Downloads"
    xdg-user-dirs-update --set XDG_MUSIC_DIR "${HOME}/Downloads"
    xdg-user-dirs-update --set XDG_TEMPLATES_DIR "${HOME}/Downloads"
    xdg-user-dirs-update --set XDG_PUBLICSHARE_DIR "${HOME}/Downloads"
    trash "${HOME}/Desktop" "${HOME}/Music" "${HOME}/Public" "${HOME}/Templates"

    trash "${HOME}/dotfiles"
}

main
