#!/bin/bash
# Setup the dotfiles


##############################################################################
# Basic config
##############################################################################


# Config yay
yay --save --nocleanmenu --nodiffmenu

# Update and Upgrade
yay -Syu

# Update timezone
timedatectl set-ntp true

# Make useful dirs
mkdir -p ~/{.Envs,Workspaces/H,Workspaces/J}

# Clean unused apps, folders and files
yay -S trash-cli
trash Desktop Music Public Templates Videos
yay -R deluge hexchat
trash ~/.config/hexchat
trash ~/.config/compton.conf


##############################################################################
# Install apps
##############################################################################


# PostgreSQL
yay -S postgresql
sudo systemctl enable postgresql.service
psql -U postgres -c "CREATE ROLE $USER WITH SUPERUSER LOGIN"

# Editor
yay -S visual-studio-code-bin neovim gedit
code --install-extension batisteo.vscode-django
code --install-extension christian-kohler.path-intellisense
code --install-extension dlasagno.wal-theme
code --install-extension iocave.customize-ui
code --install-extension magicstack.magicpython
code --install-extension mrorz.language-gettext
code --install-extension ms-python.python
code --install-extension ms-vsliveshare.vsliveshare
code --install-extension msjsdiag.debugger-for-chrome
code --install-extension pkief.material-icon-theme
code --install-extension shd101wyy.markdown-preview-enhanced
code --install-extension usernamehw.highlight-logical-line
code --install-extension visualstudioexptteam.vscodeintellicode
code --install-extension vsls-contrib.gistfs
code --install-extension waderyan.gitblame
code --install-extension wholroyd.jinja

# Browsers
yay -S brave google-chrome-stable

# Terminal
yay -S alacritty tmux heroku-cli neofetch cowsay fortune-mod figlet pipes.sh lolcat
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
trash ~/.zshrc.pre-oh-my-zsh
chsh -s "$(which zsh) $USER"
git clone https://github.com/xero/figlet-fonts ~/.local/share/figlet-fonts
git clone https://gitlab.com/dwt1/shell-color-scripts.git
sudo mkdir /opt/shell-color-scripts
sudo mv ~/shell-color-scripts/colorscripts /opt/shell-color-scripts
sudo mv ~/shell-color-scripts/colorscript.sh /usr/bin/colorscript
trash -rf ~/shell-color-scripts

# Desktop manager
yay -S rofi rofimoji polybar

# Others
yay -S mplayer unzip zip numlockx unclutter perl-anyevent-i3

# Edition
yay -S inkscape pinta

# Audio
install_pulse # Run pulseaudio builtin installer
yay -S pulseeffects

# Git setup
yay -S github-cli diff-so-fancy
git config --global pull.rebase false
git config --global core.excludesfile ~/.config/git/.gitignore
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
trash JetBrainsMono.zip
fc-cache ~/.local/share/fonts


##############################################################################
# Paste and configure dotfiles
##############################################################################


# Paste dotfiles and clean directory
mv ./* ~/
cd ..
trash dotfiles .github .git CODE_OF_CONDUCT.md CONTRIBUTING.md LICENCE README.md screenshot.png SECURITY.md setup.sh

# Give permissions to commands
chmod 711 ~/.local/bin/change-background
chmod 711 ~/.local/bin/picture-of-the-day
chmod 711 ~/.local/bin/sleep-monitor
chmod 711 ~/.local/bin/start-script

# Run picture-of-the-day one time per day at 00:00
(crontab -l ; echo "00 00 * * * picture-of-the-day") | crontab -
