<h2 align="center">Minimalistic Manjaro i3 personal dotfiles</h1>
<p align="center">Improved for productivity with Python 🐍, VSCode and Github.</p>
<p align="center">

![Screenshot](./screenshot.png)
</p>

🌟 **bk**: special script that's run in every boot and change randomly the background and all color schemes. Also, you can run it through terminal in any moment.

# Installation

Run the following commands (These restart the system at the end)
```
cd
git clone git@github.com:lucasvazq/dotfiles
cd dotfiles
./setup.sh
```

After restart, there's some manual installation steps

#### Github setup

```
git config --global user.name "YOUR_NAME"
git config --global user.email "YOUR_EMAIL"
```

Add github SSH key: https://help.github.com/es/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account


# Cheatsheet

Keybinds ($mod = Windows|Super|Mod4 key)
```sh
# Browser
$mod+F1                       Open Firefox
$mod+Shift+F1                 Open Google chrome

# Editor
$mod+F2                       Open VSCode

# Folder Manager
$mod+F3                       Open file browser
$mod+Shift+F3                 Open file browser in root mode

# Keyboard layout
$mod+q                        Change keyboard to US style
$mod+w                        Change keyboard to ES style

# Terminal
$mod+Return                   Open terminal

# Audio
$mod+Ctrl+m                   Open audio effects

# App menu
$mod+d                        Open run menu
$mod+Shift+d                  Open emoji menu
$mod+z                        Open apps menu

# Screenshot
Print                         Full screen screenshot
$mod+Shift+Print              Selectable area screenshot

# Windows Management
ARROWS: Up(k), Dowm(j), Left(h), Right(l)
$mod+Shift+q                  Kill actual window
$mod+f                        Fullscreen mode for a window
$mod+Shift+<ARROWS>           Move window up|down|left|right
$mod+r                        Resize window
$mod+Shift+space              Toggle windows mode between tiling/floating
$mod+space                    Change focus between tiling/floating windows
$mod+Ctrl+space               Toggle split mode between horizontal and vertical
$mod+<ARROWS>                 Focus window up|down|left|right
$mod+Ctrl+<Right(l)>          Next workspace
$mod+Ctrl+<Left(h)>           Prev workspace
$mod+<NUMBERS 1-9>            Switch to N workspace
$mod+Ctrl+<NUMBERS 1-9>       Move window to workspace N
$mod+Shift+<NUMBERS 1-9>      Move to N workspace with actual container

# System mode
$mod+0                        Select system mode
```

Terminal commands
```sh
# Funny
bk                            Change background image and general color scheme. Args: None | custom image
cow                           A psychedelic cow that tells your fortune
lolban                        Print a rainbow message. Args: the message

# Productivity
ed                            Open code editor
cud                           Change UTC timezone. Args: None | (hour [,minutes])

# Python
deactivate_python             Deactivate Python environment if any
```

# Todo

- Gif of bk command
- Nodejs support
- Make workspace space style
