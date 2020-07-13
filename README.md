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
# ⚙ Go to the home folder and clone the repo ⚙
cd && git clone git@github.com:lucasvazq/dotfiles && cd dotfiles

# 🔥 Start launch 🔥
./setup.sh

# 🚨 Restart the system 🚨
shutdown -r now
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

**Add Sourcery token**
Sign In and obtain a token. [Link][token_link]
Then, search for sourcery in the VSCode settings and enter the token into the Sourcery Token field.

[token_link]: https://sourcery.ai/download/?editor=vscode

## Travel guide

### How to drive through the meteorites
_The idea of ​​this setup is based on the fact that I consider there are two different moments in which we develop things. The first moment is when we do it for personal enjoyment, far from any responsibility that commits third parties. This moment is associated with when we do it for pleasure and develop for the simple fact of developing._
_The second situation in which we can find ourselves developing is when we do it because we have a responsibility with a third party, that is, when we are doing a job._
_This is why it seemed appropriate to me to have two separate folders where the works we carry out are kept, depending on the situation we are in when we develop them._
_The works that we do as hobbies are stored in `~/Workspaces/H`, those that we carry out under responsibilities are located in `~/Workspaces/J`._
_Everything related with the command interpreter, that are related to the **H** folder, are stored in `~/Workspaces/.hrc`. Everything related to the other folder, in `~/Workspaces/.jrc`._

Considering the words above, there are a couple of things to know to approach this methodology:

- The **wgc** command allows us to directly clone a repository in one of these workspaces.
<br>An example usage is: `wgc h git@github.com:jackfrued/Python-100-Days.git`, this clones [Python-100-Days][python_100_days] repo into **H** folder.

[python_100_days]: https://github.com/jackfrued/Python-100-Days

- In `~/.zshrc` there is a function called **cleanworkspaces** which calls two functions that are located in `.jrc` and`.hrc`. These functions are intended to clear all the virtual env and env variables related to their workspaces. In other words, the function found in `.jrc` should remove all non-default variables and virtual envs that are activated with some function that the user runs when working with a particular repository located in `~/Workspaces/J/`. In conclusion, when **cleanworkspaces** is called, all environment variables and virtual spaces are cleaned, and the benefit we can obtan from this is when the use of this function is automated for when we want to change the environment in which we are developing.

### Command center

Using this ship is difficult because the steering wheel has been very tunned.
I leave at hand a document that helps to know the customized keyboard shortcuts and that also lists all the useful functions that are in the terminal.

[Command center](./docs/command_center.md)
