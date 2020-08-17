<span align="center">

  # i3 Starship dotfiles

</span>

![Super-Linter](https://github.com/lucasvazq/dotfiles/workflows/Super-Linter/badge.svg?branch=master)

<p align="center">

  ![Screenshot](./docs/Gallery/screenshots.gif)
</p>

_When a new day starts, the [Astronomy Picture of the Day][astropix] is selected as your new wallpaper._
_Based on the colors of this image, the general color scheme of the rest of the components of your ship was established._
_I've improved it for coding in Python, Deno and NodeJS, using tmux, VSCode and Github._

[astropix]: https://apod.nasa.gov/apod/astropix.html

🧲 ⚡ **Requirements:** Manjaro I3

🛰 ✨ **Gallery:** [Screenshots][gallery]

[gallery]: ./docs/Gallery/

## Ready, Set, Launch 🚀

Run the following commands

```sh
# ⚙ Go to the home folder and clone the repo ⚙
cd && git clone https://github.com/lucasvazq/dotfiles.git && cd dotfiles

# 🔥 Start launch 🔥
chmod 777 ./setup.sh && ./setup.sh

# 🚨 Restart the system 🚨
shutdown -r now
```

After rebooting, there are other things you should do manually

**Establish secure communications with Github**

```sh
git config --global user.name "YOUR_NAME"
git config --global user.email "YOUR_EMAIL"
```

[Add SSH key][github_ssh_key_help]

[github_ssh_key_help]: https://help.github.com/es/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account

**Add Sourcery token**

[Click here][token_link] to Sign In and obtain a token.

Then, search for sourcery in the VSCode settings and enter the token into the Sourcery Token field.

[token_link]: https://sourcery.ai/download/?editor=vscode

## Travel guide

### How to drive through the meteorites

_The idea of ​​this setup is based on the fact that I consider there are two different moments in which we develop things._

_The first moment is when we do it for personal enjoyment, far from any responsibility that commits third parties._
_This moment is associated with when we do it for pleasure and develop for the simple fact of developing._
_The second situation in which we can find ourselves developing is when we do it because we have a responsibility with a third party, that is, when we are doing a job._

_This is why it seemed appropriate to me to have two separate folders where the works we carry out are kept, depending on the situation we are in when we develop them._
_The works that we do as hobbies are stored in `~/Workspaces/H`, those that we carry out under responsibilities are located in `~/Workspaces/J`._
_Everything related with the command interpreter, that are related to the **H** folder, are stored in `~/Workspaces/.hrc`. Everything related to the other folder, in `~/Workspaces/.jrc`._

_For databases there is also a special place. For each workspace there is a **DB** folder._
_The idea behind this is to store, in these folders, all the backup copies of the databases related to each of the repositories for each of the corresponding workspaces._

_Finally, I want to make a special mention of one more file._
_Some functions and variables belong to the workspace and that can be useful for both. That is why these functions and variables must be located in the `~/Workspaces/.crc` file._

Considering the words above, there are a couple of things to know to approach this methodology:

- The **wgc** command allows us to directly clone a repository in one of these workspaces.
<br>An example usage is: `wgc h git@github.com:jackfrued/Python-100-Days.git`, this clones [Python-100-Days][python_100_days] repo into **H** folder.

[python_100_days]: https://github.com/jackfrued/Python-100-Days

- In `~/.zshrc` there is a function called **clean** which calls two functions that are located in `.jrc` and`.hrc`.
<br>These functions are intended to clear all the virtual env and env variables related to their workspaces.
<br>In other words, the function found in `.jrc` should remove all non-default variables and virtual envs that are activated with some function that the user runs when working with a particular repository located in `~/Workspaces/J/`.
<br>In conclusion, when **clean** is called, all environment variables and virtual spaces are cleaned, and the benefit we can obtan from this is when the use of this function is automated for when we want to change the environment in which we are developing.

### Command center

Using this ship is difficult because the rudder has been very tunned.

I leave at hand a wiki that helps to know the customized keyboard shortcuts used for VSCode, ranger, tmux, and i3, and that also lists all the useful functions that are available for the shell.

[Command center](https://github.com/lucasvazq/dotfiles/wiki)
