#!/bin/bash

####################
# Init
####################

# Config yay
yay --save --nocleanmenu --nodiffmenu

# Update and Upgrade
yay -Syu

# Update timezone
timedatectl set-ntp true

# Make workspaces
mkdir ~/Workspace

# Clean unused apps, folders and files
rm -rf Desktop Music Public Templates Videos
yay -R deluge hexchat
rm -rf ~/.config/hexchat
rm ~/.config/compton.conf

####################
# Install apps
####################

# Editor
yay -S visual-studio-code-bin neovim gedit
code --install-extension christian-kohler.path-intellisense
code --install-extension CoenraadS.bracket-pair-colorizer
code --install-extension dlasagno.wal-theme
code --install-extension eamodio.gitlens
code --install-extension ms-python.python
code --install-extension ms-vsliveshare.vsliveshare
code --install-extension msjsdiag.debugger-for-chrome
code --install-extension shd101wyy.markdown-preview-enhanced
code --install-extension VisualStudioExptTeam.vscodeintellicode

# Browsers
yay -S brave google-chrome-stable tor-browser

# Terminal
yay -S alacritty neofetch cowsay fortune-mod figlet pipes.sh lolcat
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
rm ~/.zshrc.pre-oh-my-zsh
chsh -s $(which zsh) $USER
git clone https://github.com/xero/figlet-fonts ~/.local/share/figlet-fonts
git clone https://gitlab.com/dwt1/shell-color-scripts.git
sudo mkdir /opt/shell-color-scripts
sudo mv ~/shell-color-scripts/colorscripts /opt/shell-color-scripts
sudo mv ~/shell-color-scripts/colorscript.sh /usr/bin/colorscript
rm -rf ~/shell-color-scripts

# Desktop manager
yay -S rofi rofimoji polybar

# Others
yay -S unzip zip numlockx perl-anyevent-i3

# Edition
yay -S inkscape pinta

# Audio
# Run pulseaudio builtin installer
install_pulse
yay -S pulseeffects

# Git setup
yay -S github-cli diff-so-fancy
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
git config --global color.ui true
git config --global color.diff-highlight.oldNormal "red bold"
git config --global color.diff-highlight.oldHighlight "red bold 52"
git config --global color.diff-highlight.newNormal "green bold"
git config --global color.diff-highlight.newHighlight "green bold 22"
git config --global color.diff.meta "11"
git config --global color.diff.frag "magenta bold"
git config --global color.diff.commit "yellow bold"
git config --global color.diff.old "red bold"
git config --global color.diff.new "green bold"
git config --global color.diff.whitespace "red reverse"

# Python
pip install pipenv virtualenvwrapper ipython pywal --user

# Fonts
yay -S noto-fonts-emoji
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip
unzip -d ~/.local/share/fonts JetBrainsMono.zip
rm JetBrainsMono.zip
fc-cache ~/.local/share/fonts


####################
# Dotfiles
####################

# Paste dotfiles and remove directory
mv ./* ~/
cd ..
rm -rf dotfiles
rm screenshot.png

# Give permissions to commands
chmod 711 ~/.local/bin/bk.sh

# Restart system
shutdown -r now
