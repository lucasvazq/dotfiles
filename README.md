<h1 align="center">Minimalistic Manjaro i3 Starship dotfiles</h1>
<p align="center">

  ![Screenshot](./screenshot.png)
</p>

<p align="right">
  “Orion over Argentine Mountains” - Picture of the day by Nicolas Tabbush. June 9th, 2020
</p>

Every time your Starship turns on, the (https://apod.nasa.gov/apod/astropix.html)[Astronomy Picture of the Day] is selected as your new wallpaper.
Based on the colors of this image, the general color scheme of the rest of the components of your ship was established.
I've improved the ship for Python snake hunting, while the command center is built with Vscode and communications are made with the Octocat.

# Ready, Set, Launch 🚀

Run the following commands
```sh
cd && git clone git@github.com:lucasvazq/dotfiles && cd dotfiles # Positionate and dowload the repo
./setup.sh  # Start launch
shutdown -r now # restart the system
```

After restart, there's some manual installation steps

#### Establish the communication channel with Octocat

```sh
git config --global user.name "YOUR_NAME"
git config --global user.email "YOUR_EMAIL"
```

Add SSH key: https://help.github.com/es/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account

# Command Center Management

#### Windows Manager
```
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
$mod+q                      Change keyboard to US style
$mod+w                      Change keyboard to ES style

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

#### Terminal commands
```
# Tachyon Laser
picture-of-the-day          Set the Astronomy Picture of the Day as
                            background and pimp the ship with the image color
                            schema. If there is not intergalactic connection,
                            the background comes from an anonymous painter
                            alien
bk                          Change background image and general color scheme.
                            Without args, it's setup a random image from
                            ~/Pictures/Wallpapers. Else, it's setup the image
                            your pass as argument. Args: None | custom image
lolban                      Print a rainbow message. Args: message
cow                         A psychedelic cow that tells your fortune
neo                         Take selfie from space

# Productivity
ed                          Open code editor
cud                         Change UTC timezone. Args: None | (hour [,minutes])

# Python
deactivate_python           Deactivate Python environment if any
``` 

# Future travels

- Nodejs support
- Implement space dumpster
