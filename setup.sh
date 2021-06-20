#!/bin/sh
# Setup the user environment


###############################################################################
# Basic config
###############################################################################


# Ask for password and save it to don't ask for it again in the future
CORRECT_PASSWORD=false
until [ $CORRECT_PASSWORD == true ]; do
    echo -n "Password: "
    IFS= read -rs PASSWORD
    sudo -k
    if echo "$PASSWORD" | sudo -Sl &> /dev/null; then
        CORRECT_PASSWORD=true
    else
        echo -e "\nWrong password"
    fi
done

# Config yay
yay --save --answerclean None --answerdiff None --answeredit None --noremovemake --cleanafter --noprovides --sudoloop

# Update and Upgrade
yes | \
    # Roses are red
    # violets are blue
    # I have Manjaro i3
    yay -Syu

# Update timezone
echo "$PASSWORD" | sudo -S timedatectl set-ntp true

# Make useful dirs
mkdir -p ~/{.Envs,Pictures/Screenshots,Workspaces/H/DB,Workspaces/J/DB}

# Clean unused apps, folders and files
yes | yay -S trash-cli
trash ~/Desktop ~/Music ~/Public ~/Templates ~/Videos
yes | yay -R deluge hexchat
trash ~/.config/hexchat
trash ~/.config/compton.conf


###############################################################################
# Installations
###############################################################################


# Fonts
yes | yay -S noto-fonts-emoji
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip
unzip -d ~/.local/share/fonts JetBrainsMono.zip
trash JetBrainsMono.zip
fc-cache ~/.local/share/fonts

# Launcher
yes | yay -S rofi rofimoji

# Status bar
yes | yay -S polybar

# Audio
yes | yay -S lib32-jack && yes | install_pulse # run pulseaudio builtin installer
yes | yay -S pulseeffects

# Browsers
yes | yay -S brave google-chrome-stable

# Terminal
yes | yay -S alacritty tmux neofetch cowsay fortune-mod figlet pipes.sh lolcat shellcheck
yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
trash ~/.zshrc.pre-oh-my-zsh
echo "$PASSWORD" | chsh -s "$(which zsh) $USER"
git clone https://github.com/xero/figlet-fonts ~/.local/share/figlet-fonts
git clone https://gitlab.com/dwt1/shell-color-scripts.git
echo "$PASSWORD" | sudo -S mkdir /opt/shell-color-scripts
echo "$PASSWORD" | sudo -S mv ./shell-color-scripts/colorscripts /opt/shell-color-scripts
echo "$PASSWORD" | sudo -S mv ./shell-color-scripts/colorscript.sh /usr/bin/colorscript
trash -rf ./shell-color-scripts

# Code editors
yes | yay -S visual-studio-code-bin neovim gedit
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
code --install-extension vtrois.gitmoji-vscode
code --install-extension waderyan.gitblame
code --install-extension wholroyd.jinja
code --install-extension ybaumes.highlight-trailing-white-spaces

# Image editors
yes | yay -S inkscape pinta

# Git
yes | yay -S github-cli diff-so-fancy
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
echo "$PASSWORD" | sudo -S "$(curl -fsSL https://raw.githubusercontent.com/axetroy/dvm/master/install.sh | bash)"
dvm install v1.3.0
yes | yay -S nvm
nvm install node

# Others
yes | yay -S mplayer unzip zip slop numlockx unclutter perl-anyevent-i3


###############################################################################
# Paste and config the dotfiles
###############################################################################


# Paste dotfiles and clean directory
cp -r . ~/
trash ~/dotfiles ~/.git ~/.github ~/CODE_OF_CONDUCT.md ~/CONTRIBUTING.md ~/LICENSE ~/README.md ~/docs ~/SECURITY.md ~/setup.sh

# Give permissions to commands
chmod 711 ~/.local/bin/change-background
chmod 711 ~/.local/bin/custom-scrot
chmod 711 ~/.local/bin/picture-of-the-day
chmod 711 ~/.local/bin/sleep-monitor
chmod 711 ~/.local/bin/start-script

# Run picture-of-the-day one time per day at 00:00
(crontab -l ; echo "00 00 * * * picture-of-the-day") | crontab -
