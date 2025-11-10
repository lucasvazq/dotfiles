#!/usr/bin/env bash
set -euo pipefail

cd "${HOME}"

# Ask for password and save it to don't ask for it again while the installation.
local correct_password password
correct_password=false
until [ "${correct_password}" == true ]; do
    echo -n "Password: "
    IFS= read -rs password
    sudo -k
    if echo "${password}" | sudo -Sl &> /dev/null; then
        correct_password=true
    else
        echo -e "\nWrong password"
    fi
done

yes | yay --save --answerclean None --answerdiff None --answeredit None --noremovemake --sudoloop
sudo pacman-mirrors -f
yes | \
    # Roses are red
    # violets are blue
    # I have Endeavour i3
    yay -Syu

# Copy config files.
cd ~
git clone git@github.com:lucasvazq/dotfiles.git
cp dotfiles/* .

# Install packages
yay -S gnome-keyring
yay -S zsh
yay -S trash-cli
yay -S google-chrome
chsh -s "$(which zsh)"
yay -S warp-terminal-bin
yay -S starship
yay -S docker-desktop
yay -S slop
yay -S visual-studio-code-bin
yay -S github-cli
yes | yay -S neohtop
yes | yay -S libreoffice-fresh
yes | yay -S gimp shotcut

# Fonts.
yes | yay -S ttf-jetbrains-mono-nerd noto-fonts-emoji

# what about numlock?

# add CDNs
# add fonts: jetbrains noto nerd font regular
# install venv for python and then create a default one at ~/.config/Envs/Python
yes | yay -S nvm
nvm install node

git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global core.excludesfile ~/.config/git/gitignore

echo "Detecting GPU..."
GPU_INFO="$(lspci | grep -E "VGA|3D")"
echo "-> ${GPU_INFO}"

# Ensure multilib is enabled
if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    echo "Warning: [multilib] repository not enabled. 32-bit support (for Steam) won't work."
fi

if echo "${GPU_INFO}" | grep -qi "NVIDIA"; then
    echo "NVIDIA GPU detected."
    sudo pacman -S --needed nvidia-dkms nvidia-utils lib32-nvidia-utils nvidia-settings
    if echo "${GPU_INFO}" | grep -qi "Intel"; then
        echo "Hybrid Intel + NVIDIA setup detected. Installing PRIME offload support..."
        sudo pacman -S --needed nvidia-prime
    fi

elif echo "${GPU_INFO}" | grep -qi "AMD"; then
    echo "AMD GPU detected."
    sudo pacman -S --needed mesa vulkan-radeon lib32-vulkan-radeon

elif echo "${GPU_INFO}" | grep -qi "Intel"; then
    echo "Intel GPU detected."
    sudo pacman -S --needed mesa vulkan-intel lib32-vulkan-intel

else
    echo "Unknown GPU vendor. Installing generic Mesa drivers."
    sudo pacman -S --needed mesa vulkan-swrast lib32-vulkan-swrast
fi

echo "GPU driver setup completed."
echo "You can verify Vulkan with: vulkaninfo | grep 'GPU id'"

pip install pywal

yay -S steam

# Handle directories.
trash Desktop Music Public Templates dotfiles
mkdir -p Pictures/{Wallpapers,Screenshots}
mkdir -p Workspaces
chmod 711 .local/bin/change-background
chmod 711 .local/bin/custom-scrot
chmod 711 .local/bin/picture-of-the-day

# Run picture-of-the-day one time per day at 00:00
# TODO: make this.... idempotent?
(crontab -l ; echo "00 00 * * * picture-of-the-day") | crontab -

echo "remember to install KVM"
echo "RESET!"
