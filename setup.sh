#!/usr/bin/env bash
# Install the dotfiles.
set -euo pipefail

_SUDO_KEEPALIVE_PID=""

function main {
    _presentation
    _set_sudo_password

    local log_file
    log_file="${HOME}/.cache/dotfiles-$(date +%Y-%m-%d_%H-%M-%S).log"
    echo
    echo "Saving logs at ${log_file}"
    echo
    sleep 2

    local duration
    duration=$(_execute_steps 2>&1 | tee -a "${log_file}")
    _log "Done!\nDuration: ${duration}\nNext step: Check the README.md for post-installation steps!"
}

function _execute_steps {
    local start_time
    start_time="$(date +"%Y-%m-%d %H:%M:%S")"
    local original_ps4
    original_ps4="$PS4"
    export PS4='[$(basename "$0")] [$(date "+%Y-%m-%d %H:%M:%S")] '
    yay --save --builddir yay --verbose
    set -x

    _setup_configuration_files
    _configure_yay
    _install_drivers
    _install_packages
    _configure_dns
    _setup_crontab
    _cleanup_configuration_files

    set +x
    yay --save --nobuilddir
    export PS4="${original_ps4}"
    local end_time duration
    end_time="$(date +"%Y-%m-%d %H:%M:%S")"
    duration="$(_get_duration "${start_time}" "${end_time}")"
    echo "${duration}"
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
            echo
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

function _set_sudo_password {
    sudo -k
    sudo -v

    while true; do
        sudo -v || exit 0
        sleep 60
    done &
    _SUDO_KEEPALIVE_PID=$!
    trap _cleanup_sudo EXIT INT TERM
}

function _cleanup_sudo {
    sudo -K || true
    if [[ -n "${_SUDO_KEEPALIVE_PID}" ]]; then
        kill "${_SUDO_KEEPALIVE_PID}" 2>/dev/null || true
    fi
}

function _setup_configuration_files {
    _log "Configuring files..." --dont-add-top-padding

    git clone https://github.com/lucasvazq/dotfiles.git "${HOME}/dotfiles"
    rsync -a "${HOME}/dotfiles/" "${HOME}/"

    mkdir -p "${HOME}/Pictures/Screenshots"
    mkdir -p "${HOME}/Workspaces"
}

function _configure_yay {
    _log "Configuring yay..."

    sudo bash -c \
    'echo "$(whoami) ALL=(ALL) NOPASSWD: /usr/bin/yay" > /etc/sudoers.d/00-yay-nopasswd'
    sudo chmod 440 /etc/sudoers.d/00-yay-nopasswd
    yes | yay --save --answerclean None --answerdiff None --answeredit None --noremovemake --sudoloop || true
    yes | yay -S eos-rankmirrors || true
    sudo eos-rankmirrors

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

    # GPU Drivers.
    local gpu_info
    gpu_info="$(lspci | grep -E "VGA|3D")"
    if echo "${gpu_info}" | grep -qi "NVIDIA"; then
        yes | yay -S nvidia-inst || true
        sudo nvidia-inst
    elif echo "${gpu_info}" | grep -qi "AMD"; then
        yes | yay -S extra/mesa extra/vulkan-radeon multilib/lib32-vulkan-radeon || true
    elif echo "${gpu_info}" | grep -qi "Intel"; then
        yes | yay -S extra/mesa extra/vulkan-intel multilib/lib32-vulkan-intel || true
    else
        yes | yay -S extra/mesa extra/vulkan-swrast multilib/lib32-vulkan-swrast || true
    fi
}

function _install_packages {
    _log "Installing packages..."

    # Utilities & Required by system.
    yes | yay -S \
    extra/trash-cli \
    extra/gnome-keyring \
    extra/slop extra/qt5ct aur/themix-theme-oomox-git \
    aur/xkblayout-state-git extra/ttf-jetbrains-mono-nerd extra/noto-fonts-emoji \
    extra/qt6-multimedia-ffmpeg \
    || true

    # Shell.
    yes | yay -S extra/zsh extra/starship || true
    sudo chsh -s "$(command -v zsh)" "$USER"

    # Apps.
    yes | yay -S \
    aur/google-chrome \
    aur/visual-studio-code-bin aur/postman-bin \
    extra/kitty \
    extra/libreoffice-fresh \
    extra/gimp extra/kdenlive extra/obs-studio \
    aur/neohtop \
    multilib/steam \
    || true

    # File manager.
    local size
    size=$((8 * 1024 * 1024 * 1024)) # 8 GiB
    yes | yay -S extra/nemo
    gsettings set org.nemo.preferences show-image-thumbnails always
    gsettings set org.nemo.preferences thumbnail-limit "${size}"
    gsettings set org.gnome.desktop.privacy remember-recent-files false

    # Github & Git.
    systemctl --user enable ssh-agent.service
    yes | yay -S extra/github-cli extra/diff-so-fancy || true
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    git config --global core.excludesfile "${HOME}/.config/git/gitignore"
    git config --global core.pager "diff-so-fancy | less --tabs=4 -RF"
    git config --global interactive.diffFilter "diff-so-fancy --patch"
    git config --bool --global diff-so-fancy.stripLeadingSymbols false

    # Docker.
    yes | yay -S aur/docker-desktop || true
    sudo usermod -aG docker "${USER}"
    sudo rm -f /etc/firewalld/policies/docker*
    sudo rm -f /etc/firewalld/zones/docker*
    sudo firewall-cmd --permanent --delete-zone=docker || true
    sudo firewall-cmd --permanent --delete-zone=docker-forwarding || true
    sudo firewall-cmd --reload
    sudo systemctl enable docker

    # Python.
    python -m venv "${HOME}/.config/.venv"
    source "${HOME}/.config/.venv/bin/activate"
    pip install pywal colorthief ipython ipdb requests
    deactivate

    # JavaScript.
    yes | yay -S extra/nvm || true
    source /usr/share/nvm/init-nvm.sh
    nvm install node
}

function _configure_dns {
    _log "Configuring DNS..."

    printf "nameserver 8.8.8.8\nnameserver 8.8.4.4\n" \
    | sudo tee /etc/resolv.conf > /dev/null
    printf "[main]\ndns=none\n" \
    | sudo tee /etc/NetworkManager/NetworkManager.conf > /dev/null
}

function _setup_crontab {
    _log "Adding Crontab..."

    yes | yay -S aur/systemd-cron-next-git || true

    local job current
    job="0 */6 * * * ${HOME}/.local/bin/picture-of-the-day"
    current="$(crontab -l 2>/dev/null || true)"
    if ! echo "${current}" | grep -Fq -- "${job}"; then
        ( printf "%s\n" "${current}"; printf "%s\n" "${job}" ) | crontab -
    fi
}

function _cleanup_configuration_files {
    _log "Cleaning files..."

    # Merge most of default folders into the Downloads folder.
    xdg-user-dirs-update --set XDG_DESKTOP_DIR "${HOME}/Downloads"
    xdg-user-dirs-update --set XDG_MUSIC_DIR "${HOME}/Downloads"
    xdg-user-dirs-update --set XDG_TEMPLATES_DIR "${HOME}/Downloads"
    xdg-user-dirs-update --set XDG_PUBLICSHARE_DIR "${HOME}/Downloads"
    trash "${HOME}/Desktop" "${HOME}/Music" "${HOME}/Public" "${HOME}/Templates" || true

    trash "${HOME}/dotfiles"

    sudo rm /etc/sudoers.d/00-yay-nopasswd
}

function _get_duration {
    local start_time end_time
    start_time="$1"
    end_time="$2"

    local duration_in_seconds hours minutes seconds
    duration_in_seconds="$(($(date -u -d "${end_time}" +"%s") - $(date -u -d "${start_time}" +"%s")))"
    hours=$((duration_in_seconds / 3600))
    minutes=$(((duration_in_seconds % 3600) / 60))
    seconds=$((duration_in_seconds % 60))

    local response
    response=""
    if [[ "${hours}" -gt 0 ]]; then
        response="${hours}h "
    fi
    if [[ "${minutes}" -gt 0 ]]; then
        if [[ -n "${response}" ]]; then
            response="${response} "
        fi
        response="${response}${minutes}m"
    fi
    if [[ "${seconds}" -gt 0 ]]; then
        if [[ -n "${response}" ]]; then
            response="${response} "
        fi
        response="${response}${seconds}s"
    fi

    echo "${response}"
}

function _log {
    local message top_padding
    message="$1"
    if [[ -n "${2:-}" ]]; then
        if [[ "$2" == "--dont-add-top-padding" ]]; then
            top_padding=false
        else
            exit 1
        fi
    else
        top_padding=true
    fi

    local x_activated
    if set -o | grep xtrace | grep on; then
        x_activated=true
        set +x
    else
        x_activated=false
    fi

    local main_color reset
    main_color="\e[96m"
    reset="\e[0m"
    if "${top_padding}" | "${x_activated}"; then
        echo -e "${main_color}"
    else
        echo -en "${main_color}"
    fi
    echo -e "================================"
    echo -e "${message}"
    echo -e "================================"
    echo -e "${reset}"

    if "${x_activated}"; then
        set -x
    fi
}

main
