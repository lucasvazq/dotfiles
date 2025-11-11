<span align="center">

  # i3 Starship dotfiles

```
TODO
add slop
google-chrome-stable

sudo usermod -aG docker $USER
sudo rm /etc/firewalld/policies/docker*
sudo rm /etc/firewalld/zones/docker*
sudo firewall-cmd --permanent --delete-zone=docker | true
sudo firewall-cmd --permanent --delete-zone=docker-forwarding | true
sudo firewall-cmd --reload
sudo systemctl enable docker

# yes | yay -S python-pip ?
```

</span>

_Made with love, from my own dreams._
_Casual and simple environment ready to develop with VS Code, Github, JavaScript and Python, and also play games with Steam._
_When a new day starts, the [Astronomy Picture of the Day][astropix] is selected as your new wallpaper._

[astropix]: https://apod.nasa.gov/apod/astropix.html

🧲 ⚡ **Requirements:** [EndeavourOS i3]

[EndeavourOS i3]: https://endeavouros.com/

## Installation

```sh
bash <(curl -s https://raw.githubusercontent.com/lucasvazq/dotfiles/main/setup.sh)
```

**Post installation**

```
gh auth login
git config --global user.name "YOUR_NAME"
git config --global user.email "YOUR_EMAIL"
```
