<span align="center">

# Minimalistic i3 Starship dotfiles
</span>

![Super-Linter](https://github.com/lucasvazq/dotfiles/workflows/Super-Linter/badge.svg?branch=master)

<p align="center">

  ![Screenshot](./screenshot.png)
</p>

When a new day starts, the [Astronomy Picture of the Day][astropix] is selected as your new wallpaper.
Based on the colors of this image, the general color scheme of the rest of the components of your ship was established.
I've improved it for Python hunting, while the command center is built with Vscode, the database is handled by psqalien and communications are done with Octocat and Heroku.

[astropix]: https://apod.nasa.gov/apod/astropix.html

🧲 ⚡ **Requirements:** Manjaro I3

## Ready, Set, Launch 🚀

Run the following commands
```sh
cd && git clone git@github.com:lucasvazq/dotfiles && cd dotfiles # Positionate and download the repo
./setup.sh # Start launch
shutdown -r now # Restart the system
```

After rebooting, there are other commands you should run on the fly

**Establish the communication channel with Octocat and Heroku**
```sh
heroku login
git config --global user.name "YOUR_NAME"
git config --global user.email "YOUR_EMAIL"
```
[Add SSH key][github_ssh_key_help]

[github_ssh_key_help]: https://help.github.com/es/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account

## Command Center Management

**Windows Manager**
```txt
Keybinds ($mod = Windows|Super|Mod4 key)

# Browser
$mod+F1                     Open Brave
$mod+Shift+F1               Open Google chrome

# Editor
$mod+F2                     Open VSCode

# Folder Manager
$mod+F3                     Open file browser
$mod+Shift+F3               Open file browser in root mode

# Keyboard layout
$mod+q                      Change keyboard to US style 🇺🇸
$mod+w                      Change keyboard to ES style 🇪🇦

# Terminal
$mod+Return                 Open terminal

# Audio
$mod+Ctrl+m                 Open audio effects

# App menu
$mod+d                      Open run menu
$mod+Shift+d                Open emoji menu
$mod+z                      Open apps menu

# Screenshot
Print                       Full screen screenshot
$mod+Shift+Print            Selectable area screenshot

# Windows Management
ARROWS: Up(k), Dowm(j), Left(h), Right(l)
$mod+Shift+q                Kill actual window
$mod+f                      Fullscreen mode for a window
$mod+Shift+<ARROWS>         Move window up|down|left|right
$mod+r                      Resize window
$mod+Shift+space            Toggle windows mode between tiling/floating
$mod+space                  Change focus between tiling/floating windows
$mod+Ctrl+space             Toggle split mode between horizontal and vertical
$mod+<ARROWS>               Focus window up|down|left|right
$mod+Ctrl+<Right(l)>        Next workspace
$mod+Ctrl+<Left(h)>         Prev workspace
$mod+<NUMBERS 1-9>          Switch to N workspace
$mod+Ctrl+<NUMBERS 1-9>     Move window to workspace N
$mod+Shift+<NUMBERS 1-9>    Move to N workspace with actual container

# System mode
$mod+0                      Select ship mode
```

**Terminal commands**
```txt
# Tachyon Laser
bk                          Change background image and general color scheme.
                            Without args, it's setup a random image from
                            ~/Pictures/Wallpapers. Else, it's setup the image
                            your pass as argument
desc                        Print the description of the Astronomic Picture of the Day
fav                         Select preferred color schema
lolban                      Print a rainbow message
cow                         A psychedelic cow that tells your fortune
neo                         Take selfie from space

# Productivity
ed                          Open code editor
cud                         Change UTC timezone. You can pass hours and minutes
                            or just nothig for restore time
wgc                         Clone a repo in any of the workspaces

# Servers
drs                         Run Django server
hl                          Run Heroku local
ds                          Open Django shell. You can specify a db schema
hrs                         Open Django shell in a Heroku App. You can specify
                            a db schema
hrq                         Open PostgreSQL CLI in a Heroku App

# Python
pyc                         Create Python environment
pya                         Activate Python environment
pyl                         List all Python environments
pyr                         Remove Python environment
pyd                         Deactivate Python environment if any
```
