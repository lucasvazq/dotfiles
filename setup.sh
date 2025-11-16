#!/usr/bin/env bash
# Install the dotfiles.
set -euo pipefail

_TEMP_PASSWORD=""

function main {
    _presentation

    local password
    _get_password
    password="${_TEMP_PASSWORD}"
    _TEMP_PASSWORD=""

    echo "Saving logs at ${HOME}/.cache/dotfiles.log"
    sleep 2

    _setup_configuration_files
    _configure_yay "${password}"
    _install_drivers "${password}"
    _install_packages "${password}"
    _configure_dns "${password}"
    _setup_crontab
    _post_installation_cleanup

    _log "Post installation: Look at the README.md for next steps!"
}

function _presentation {
    local last_frame
    last_frame=false

    function _show_frame_lines() {
        local frames
        frames=("$@")
        clear
        echo -e "\n"
        echo -e "${frames[@]}"
        if ! "${last_frame}"; then
            echo ""
            sleep 0.1
        fi
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
    last_frame=true
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
            echo -e "\n"
        else
            echo -e "\nWrong password"
        fi
    done

    _TEMP_PASSWORD="${password}"
}

function _setup_configuration_files {
    _log "Configuring files..."

    git clone https://github.com/lucasvazq/dotfiles.git "${HOME}/dotfiles"
    rsync -a "${HOME}/dotfiles/" "${HOME}/"

    chmod 711 "${HOME}/.local/bin/change-background"
    chmod 711 "${HOME}/.local/bin/custom-scrot"
    chmod 711 "${HOME}/.local/bin/picture-of-the-day"
    mkdir -p "${HOME}/Pictures"/{Wallpapers,Screenshots}
    mkdir -p "${HOME}/Workspaces"
}

function _configure_yay {
    _log "Configuring yay..."

    local password
    password="$1"

    echo "$password" | sudo -S bash -c 'echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/bin/yay" > /etc/sudoers.d/00-yay-nopasswd'
    echo "$password" | sudo -S chmod 440 /etc/sudoers.d/00-yay-nopasswd
    yes | yay --save --answerclean None --answerdiff None --answeredit None --noremovemake --sudoloop || true
    yes | yay -S eos-rankmirrors || true
    echo "${password}" | sudo -S -k eos-rankmirrors

    yes | \
        # Roses are red
        # violets are blue
        # I have Endeavour i3
        yay -Syu \
            \
            || true
}

function _install_drivers {
    _log "Installing drivers..."

    local password
    password="$1"

    # GPU Drivers.
    local gpu_info
    gpu_info="$(lspci | grep -E "VGA|3D")"
    if echo "${gpu_info}" | grep -qi "NVIDIA"; then
        yes | yay -S nvidia-inst || true
        echo "${password}" | sudo -S -k nvidia-inst
    elif echo "${gpu_info}" | grep -qi "AMD"; then
        yes | yay -S mesa vulkan-radeon lib32-vulkan-radeon || true
    elif echo "${gpu_info}" | grep -qi "Intel"; then
        yes | yay -S mesa vulkan-intel lib32-vulkan-intel || true
    else
        yes | yay -S mesa vulkan-swrast lib32-vulkan-swrast || true
    fi
}

function _install_packages {
    _log "Installing packages..."

    local password
    password="$1"

    # Utilities & Required by system.
    yes | yay -S \
        trash-cli \
        gnome-keyring \
        slop python-pywal python-colorthief qt5ct themix-theme-oomox-git \
        xkblayout-state ttf-jetbrains-mono-nerd noto-fonts-emoji \
        qt6-multimedia-ffmpeg \
        || true

    # Shell.
    yes | yay -S zsh starship || true
    echo "${password}" | chsh -s "$(command -v zsh)"

    # Apps.
    yes | yay -S \
        nemo \
        google-chrome \
        visual-studio-code-bin warp-terminal-bin postman-bin \
        libreoffice-fresh \
        gimp kdenlive \
        neohtop \
        steam \
        || true

    # Github & Git.
    yes | yay -S github-cli || true
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    git config --global core.excludesfile "${HOME}/.config/git/gitignore"

    # Docker.
    yes | yay -S docker-desktop || true
    echo "${password}" | sudo -S -k usermod -aG docker "${USER}"
    echo "${password}" | sudo -S -k rm -f /etc/firewalld/policies/docker*
    echo "${password}" | sudo -S -k rm -f /etc/firewalld/zones/docker*
    echo "${password}" | sudo -S -k firewall-cmd --permanent --delete-zone=docker || true
    echo "${password}" | sudo -S -k firewall-cmd --permanent --delete-zone=docker-forwarding || true
    echo "${password}" | sudo -S -k firewall-cmd --reload
    echo "${password}" | sudo -S -k systemctl enable docker

    # Python.
    python -m venv "${HOME}/.config/.venv"
    source "${HOME}/.config/.venv/bin/activate"
    pip install ipython
    deactivate

    # JavaScript.
    yes | yay -S nvm || true
    source /usr/share/nvm/init-nvm.sh
    nvm install node
}

function _configure_dns {
    _log "Configuring DNS..."

    local password
    password="$1"

    { printf "%s\n" "${password}"; printf "nameserver 8.8.8.8\nnameserver 8.8.4.4\n"; } \
        | sudo -S -k tee /etc/resolv.conf > /dev/null
    { printf "%s\n" "${password}"; printf "[main]\ndns=none\n"; } \
        | sudo -S -k tee /etc/NetworkManager/NetworkManager.conf > /dev/null
}

function _setup_crontab {
    _log "Adding Crontab..."

    yes | yay -S systemd-cron || true

    local job current
    job="00 00 * * * ${HOME}/.local/bin/picture-of-the-day"
    current="$(crontab -l 2>/dev/null || true)"
    if ! grep -Fqx -- "${job}" <<< "${current}"; then
        ( printf "%s\n" "${current}"; printf "%s\n" "${job}" ) | crontab -
    fi
}

function _post_installation_cleanup {
    _log "Cleaning files..."

    gsettings set org.gnome.desktop.privacy remember-recent-files false

    # Merge most of default folders into the Downloads folder.
    xdg-user-dirs-update --set XDG_DESKTOP_DIR "${HOME}/Downloads"
    xdg-user-dirs-update --set XDG_MUSIC_DIR "${HOME}/Downloads"
    xdg-user-dirs-update --set XDG_TEMPLATES_DIR "${HOME}/Downloads"
    xdg-user-dirs-update --set XDG_PUBLICSHARE_DIR "${HOME}/Downloads"
    trash "${HOME}/Desktop" "${HOME}/Music" "${HOME}/Public" "${HOME}/Templates" || true

    trash "${HOME}/dotfiles"

    echo "${password}" | sudo -S -k rm /etc/sudoers.d/00-yay-nopasswd
}

function _log {
    local message
    message="$1"

    local main_color reset
    main_color="\e[96m"
    reset="\e[0m"

    echo -e "${main_color}"
    echo -e "================================"
    echo -e " [setup.sh] ${message}"
    echo -e "================================"
    echo -e "${reset}"
}

main 2>&1 | tee -a "${HOME}/.cache/dotfiles.log"
