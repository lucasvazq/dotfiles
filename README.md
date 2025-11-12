<div align="center">

  # i3 Starship dotfiles

</div>

<div align="center">
  <picture>
    <source srcset="..." type="image/png">
    <img src="./..." alt="logo">
  </picture>
</div>

<div align="center">
  <sub><i>Made with love, from my own dreams.</i></sub>
</div>

---

_Casual and simple environment ready to develop with VS Code, Github, JavaScript and Python, and also play games with Steam._ \
_When a new day starts, the [Astronomy Picture of the Day][astropix] is selected as your new wallpaper._

[astropix]: https://apod.nasa.gov/apod/astropix.html

🧲 ⚡ **Requirements:** [EndeavourOS i3]

[EndeavourOS i3]: https://endeavouros.com/

## Installation

```sh
bash <(curl -s https://raw.githubusercontent.com/lucasvazq/dotfiles/main/setup.sh)
```

**Post-Installation Steps**

- Reboot the PC.
- Setup KVM (Kernel-based Virtual Machine) on BIOS/UEFI.
- Setup GitHub & Git.

Setup Github & Git:
```sh
gh auth login --hostname github.com --git-protocol ssh
git config --global user.name "<YOUR_NAME>"
git config --global user.email "<YOUR_EMAIL>"
git remote set-url origin git@github.com:lucasvazq/dotfiles.git
```
