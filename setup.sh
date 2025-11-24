#!/usr/bin/env bash
# Install the dotfiles.
set -euo pipefail

_SUDO_KEEPALIVE_PID=""

function main {
    local action
    action="${1:---install}"

    _presentation
    _set_sudo_password

    local log_file
    log_file="${HOME}/.cache/dotfiles-$(date +%Y-%m-%d_%H-%M-%S).log"
    echo
    echo "Saving logs at ${log_file}"
    echo
    sleep 2

    local start_time end_time duration
    start_time="$(date +%s)"

    export PS4='$(date "+%Y-%m-%d %H:%M:%S") '
    case "${action}" in
        --install)
            _execute_installation_steps 2>&1 | tee -a "${log_file}"
        ;;
        --post-install)
            _execute_post_installation_steps 2>&1 | tee -a "${log_file}"
        ;;
    esac

    end_time="$(date +%s)"
    duration="$(_get_duration "${start_time}" "${end_time}")"
    case "${action}" in
        --install)
            _log "Installation Done!\nDuration: ${duration}\nNext step: Check the README.md for post-installation steps!"
        ;;
        --post-install)
            _log "Post-installation Done!\nDuration: ${duration}\nEnjoy! (no additional steps or restart are required)"
        ;;
    esac
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

function _get_duration {
    local start_time end_time
    start_time="$1"
    end_time="$2"

    local duration hours minutes seconds
    duration="$((end_time - start_time))"
    hours=$((duration / 3600))
    minutes=$(((duration % 3600) / 60))
    seconds=$((duration % 60))

    local parsed_duration
    parsed_duration=""
    if [[ "${hours}" -gt 0 ]]; then
        parsed_duration="${hours}h "
    fi
    if [[ "${minutes}" -gt 0 ]]; then
        if [[ -n "${parsed_duration}" ]]; then
            parsed_duration="${parsed_duration} "
        fi
        parsed_duration="${parsed_duration}${minutes}m"
    fi
    if [[ "${seconds}" -gt 0 ]]; then
        if [[ -n "${parsed_duration}" ]]; then
            parsed_duration="${parsed_duration} "
        fi
        parsed_duration="${parsed_duration}${seconds}s"
    fi

    echo "${parsed_duration}"
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
    if "${top_padding}" || "${x_activated}"; then
        echo -e "${main_color}"
    else
        echo -en "${main_color}"
    fi
    separator_length=64
    printf '%s\n' "$(printf '=%.0s' $(seq 1 "${separator_length}"))"
    echo -e "${message}"
    printf '%s\n' "$(printf '=%.0s' $(seq 1 "${separator_length}"))"
    echo -e "${reset}"

    if "${x_activated}"; then
        set -x
    fi
}

################################################################################
# Installation steps.
################################################################################

function _execute_installation_steps {
    set -x
    _setup_configuration_files
    _configure_yay
    _install_drivers
    _install_packages
    _setup_crontab
    _cleanup_configuration_files
    set +x
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
    yes | yay --verbose --noconfirm -S eos-rankmirrors || true
    sudo eos-rankmirrors

    yes | \
        # Roses are red
        # violets are blue
        # I have Endeavour i3
        yay -Syu \
    --verbose --noconfirm \
    || true
}

function _install_drivers {
    _log "Installing drivers..."

    # GPU Drivers.
    local gpu_info
    gpu_info="$(lspci | grep -E "VGA|3D")"
    if echo "${gpu_info}" | grep -qi "NVIDIA"; then
        yes | yay --verbose --noconfirm -S nvidia-inst || true
        sudo nvidia-inst
    elif echo "${gpu_info}" | grep -qi "AMD"; then
        yes | yay --verbose --noconfirm -S extra/mesa extra/vulkan-radeon multilib/lib32-vulkan-radeon || true
    elif echo "${gpu_info}" | grep -qi "Intel"; then
        yes | yay --verbose --noconfirm -S extra/mesa extra/vulkan-intel multilib/lib32-vulkan-intel || true
    else
        yes | yay --verbose --noconfirm -S extra/mesa extra/vulkan-swrast multilib/lib32-vulkan-swrast || true
    fi
}

function _install_packages {
    _log "Installing packages..."

    # Utilities & Required by system.
    yes | yay --verbose --noconfirm -S \
    extra/trash-cli \
    extra/gnome-keyring \
    extra/slop extra/qt5ct aur/themix-theme-oomox-git \
    aur/xkblayout-state-git extra/ttf-jetbrains-mono-nerd extra/noto-fonts-emoji \
    extra/qt6-multimedia-ffmpeg \
    || true

    # Terminal & Shell.
    yes | yay --verbose --noconfirm -S extra/kitty extra/zsh extra/starship || true
    sudo chsh -s "$(command -v zsh)" "${USER}"

    # Apps.
    yes | yay --verbose --noconfirm -S \
    aur/google-chrome \
    aur/visual-studio-code-bin aur/postman-bin \
    extra/libreoffice-fresh \
    extra/gimp extra/kdenlive extra/obs-studio \
    aur/neohtop \
    multilib/steam \
    || true
    xdg-settings set default-web-browser google-chrome-stable.desktop || true
    xdg-settings set default-url-scheme-handler http google-chrome-stable.desktop || true
    xdg-settings set default-url-scheme-handler https google-chrome-stable.desktop || true

    # Files manager.
    local size
    size=$((8 * 1024 * 1024 * 1024)) # 8 GiB
    yes | yay --verbose --noconfirm -S extra/nemo || true
    gsettings set org.nemo.preferences show-image-thumbnails always
    gsettings set org.nemo.preferences thumbnail-limit "${size}"
    gsettings set org.gnome.desktop.privacy remember-recent-files false

    # Git & Github.
    systemctl --user enable ssh-agent.service
    yes | yay --verbose --noconfirm -S extra/github-cli extra/diff-so-fancy || true
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    git config --global core.excludesfile "${HOME}/.config/git/gitignore"
    git config --global core.pager "diff-so-fancy | less --tabs=4 -RF"
    git config --global interactive.diffFilter "diff-so-fancy --patch"
    git config --bool --global diff-so-fancy.stripLeadingSymbols false

    # Docker.
    yes | yay --verbose --noconfirm -S aur/docker-desktop || true
    sudo groupadd docker || true
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
    yes | yay --verbose --noconfirm -S extra/nvm || true
    source /usr/share/nvm/init-nvm.sh
    nvm install node
}

function _setup_crontab {
    _log "Adding Crontab..."

    yes | yay --verbose --noconfirm -S extra/cronie || true

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
    trash -rf "${HOME}/Desktop" "${HOME}/Music" "${HOME}/Public" "${HOME}/Templates"

    trash "${HOME}/dotfiles"

    sudo rm /etc/sudoers.d/00-yay-nopasswd
}

################################################################################
# Post-installation steps.
################################################################################

function _execute_post_installation_steps {
    local github_email
    echo -n "Enter your GitHub email: "
    IFS= read -r github_email

    set -x
    _configure_dns
    _configure_github_account "${github_email}"
    _load_kvm_modules
    set +x
}

function _configure_dns {
    _log "Configuring DNS..."

    printf "nameserver 8.8.8.8\nnameserver 8.8.4.4\n" \
    | sudo tee /etc/resolv.conf
    printf "[main]\ndns=none\n" \
    | sudo tee /etc/NetworkManager/NetworkManager.conf
}

function _configure_github_account {
    _log "Configuring GitHub account..."

    local github_email
    github_email="$1"

    if ! gh auth status; then
        set +x
        echo
        printf "y\n\n\n\n" | gh auth login --hostname github.com --git-protocol ssh --web
        set -x
    fi

    local github_username
    github_username="$(gh auth status | grep account | head -1 | awk '{print $7}')"
    ssh-add ~/.ssh/* || true
    ssh-keyscan github.com >> ~/.ssh/known_hosts
    git config --global user.name "${github_username}"
    git config --global user.email "${github_email}"
    git remote set-url origin git@github.com:lucasvazq/dotfiles.git
}

function _load_kvm_modules {
    _log "Loading KVM modules..."

    yes | yay --verbose --noconfirm -S qemu libvirt || true
    sudo systemctl enable --now libvirtd
    sudo usermod -aG libvirt "${USER}"
}

################################################################################
# Execute main function.
################################################################################

main "$@"
