#!/bin/sh
# Setup the user environment


###############################################################################
# Basic config
###############################################################################


# Ask for password and save it to don't ask for it again in the future
local correct_password password
correct_password=false
until [ $correct_password ]; do
    echo -n "Password: "
    IFS= read -rs password
    sudo -k
    if echo "$password" | sudo -Sl &> /dev/null; then
        correct_password=true
    fi
done

# Config yay
yay --save --answerclean None --answerdiff None --answeredit None --noremovemake --cleanafter --noprovides

# Update and Upgrade
yay -Syu --noconfirm

# Update timezone
echo "$password" | sudo -S timedatectl set-ntp true

# Make useful dirs
mkdir -p ~/{.Envs,Workspaces/H/DB,Workspaces/J/DB}

# Clean unused apps, folders and files
yes | yay -S --noconfirm trash-cli
trash ~/Desktop ~/Music ~/Public ~/Templates ~/Videos
yes | yay -R --noconfirm deluge hexchat
trash ~/.config/hexchat
trash ~/.config/compton.conf


###############################################################################
# Installations
###############################################################################


# Fonts
yes | yay -S --noconfirm noto-fonts-emoji
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip
unzip -d ~/.local/share/fonts JetBrainsMono.zip
trash JetBrainsMono.zip
fc-cache ~/.local/share/fonts

# Launcher
yes | yay -S --noconfirm rofi rofimoji

# Status bar
yes | yay -S --noconfirm polybar

# Audio
yes | yay -S lib32-jack && yes | install_pulse # run pulseaudio builtin installer
yes | yay -S --noconfirm pulseeffects

# Browsers
yes | yay -S --noconfirm brave google-chrome-stable

# Terminal
yes | yay -S --noconfirm alacritty tmux neofetch cowsay fortune-mod figlet pipes.sh lolcat shellcheck
yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
trash ~/.zshrc.pre-oh-my-zsh
echo "$password" | chsh -s "$(which zsh) $USER"
git clone https://github.com/xero/figlet-fonts ~/.local/share/figlet-fonts
git clone https://gitlab.com/dwt1/shell-color-scripts.git
sudo mkdir /opt/shell-color-scripts
sudo mv ./shell-color-scripts/colorscripts /opt/shell-color-scripts
sudo mv ./shell-color-scripts/colorscript.sh /usr/bin/colorscript
trash -rf ./shell-color-scripts

# Code editors
yes | yay -S --noconfirm visual-studio-code-bin neovim gedit
code --install-extension alefragnani.bookmarks
code --install-extension batisteo.vscode-django
code --install-extension be5invis.vscode-icontheme-nomo-dark
code --install-extension bierner.markdown-checkbox
code --install-extension christian-kohler.path-intellisense
code --install-extension chunsen.bracket-select
code --install-extension dbaeumer.vscode-eslint
code --install-extension dlasagno.wal-theme
code --install-extension esbenp.prettier-vscode
code --install-extension iocave.customize-ui
code --install-extension kaiwood.indentation-level-movement
code --install-extension krnik.vscode-jumpy
code --install-extension magicstack.magicpython
code --install-extension mechatroner.rainbow-csv
code --install-extension mrorz.language-gettext
code --install-extension ms-python.python
code --install-extension ms-python.vscode-pylance
code --install-extension ms-vsliveshare.vsliveshare
code --install-extension msjsdiag.debugger-for-chrome
code --install-extension oderwat.indent-rainbow
code --install-extension ryu1kn.text-marker
code --install-extension sirmspencer.vscode-autohide
code --install-extension sourcery.sourcery
code --install-extension usernamehw.errorlens
code --install-extension usernamehw.highlight-logical-line
code --install-extension visualstudioexptteam.vscodeintellicode
code --install-extension vsls-contrib.gistfs
code --install-extension waderyan.gitblame
code --install-extension wholroyd.jinja
code --install-extension ybaumes.highlight-trailing-white-spaces

# Image editors
yes | yay -S --noconfirm inkscape pinta

# Others
yes | yay -S --noconfirm mplayer unzip zip numlockx unclutter perl-anyevent-i3

# Git
yes | yay -S --noconfirm github-cli diff-so-fancy
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
pip install pipenv virtualenvwrapper ipython ipykernel pywal --user

# Deno and NodeJS
curl -fsSL https://deno.land/x/install/install.sh | sh
yes | yay -S --noconfirm nvm
nvm install node


###############################################################################
# Paste and config the dotfiles
###############################################################################


# Paste dotfiles and clean directory
cp -r . ~/
trash ~/dotfiles ~/.git ~/.github ~/CODE_OF_CONDUCT.md ~/CONTRIBUTING.md ~/LICENSE ~/README.md ~/docs ~/screenshots.gif ~/SECURITY.md ~/setup.sh

# Give permissions to commands
chmod 711 ~/.local/bin/change-background
chmod 711 ~/.local/bin/picture-of-the-day
chmod 711 ~/.local/bin/sleep-monitor
chmod 711 ~/.local/bin/start-script

# Run picture-of-the-day one time per day at 00:00
(crontab -l ; echo "00 00 * * * picture-of-the-day") | crontab -
