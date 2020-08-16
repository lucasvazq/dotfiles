#!/bin/sh


###############################################################################
# General config
###############################################################################


# Start new terminals with tmux and add pywal color scheme
if ! { [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; } then
  # Prevent lose color scheme for new tmux sessions
  wal -R -e -q

  tmux
else
  # Add wal color schema to the main terminal
  cat ~/.cache/wal/sequences
fi

# Custom programs path
source ~/Programs/.programsrc

# zsh config
export ZSH=~/.oh-my-zsh
export ZSH_THEME=custom
export plugins=(git virtualenv shrink-path)
source $ZSH/oh-my-zsh.sh

# Custom ls config
alias ls="ls -F -h --color=always -a"


###############################################################################
# Weird zone
###############################################################################


function bk {
  # Change background and color scheme, and run neo function
  #
  # The color scheme is set using the selected background
  #
  # Args:
  #   $1 (optional): wallpaper path
  #
  # Without args:
  #   Select a random wallpaper
  sh change-background >> /dev/null "$1"
  clear
  neo
}

function desc {
  # Print the description of the Astronomic Picture of the Day
  cat ~/.config/wal/image-description.txt
}
desc # run at start

function fav {
  # Set preferred color schema
  # Good themes:
  # - base16-materia
  # - sexy-theme2
  wal -q --theme base16-materia
}

function lolban {
  # Print a rainbow message with special ASCII font
  #
  # Args:
  #   $1: message
  if [ -z "$1" ]; then
    echo Miss message
    return 1
  fi

  # Cool fonts list:
  # - ~/.local/share/figlet-fonts/3d.flf
  figlet "$@" -f ~/.local/share/figlet-fonts/3d.flf | lolcat
}

function cow {
  # Invoke a psychedelic cow that tells your fortune
  fortune | cowsay -w -f three-eyes | lolcat
}

function neo {
  # Run a custom neofetch config

  # If Ctrl+C is pressed, we clear the screen
  trap clear INT

  neofetch

  # Return as a success after press Ctrl+C
  return 0
}


###############################################################################
# Productivity
###############################################################################


# Alias for open the default UI editor
alias ed=code

function open {
  # Open a link in the default browser
  #
  # Args:
  #   $1: link
  if [ -z "$1" ]; then
    echo Miss link
    return 1
  fi

  $BROWSER "$1"
}

function cud {
  # Interact with the current datetime
  #
  # You can change the datetime using UTC timezone, passing, in the following order, year, month, days, hours, and/or
  # minutes.
  # All of these args are optional, and you can pass a year without passing month using the next format: "cud 2020".
  # This set the actual year to 2020, keeping all other values.
  # Also, you can pass month ignoring year using a dot (.). E.g. "cud . 12". This set the month to December,
  # keeping all other values.
  # Another example: "cud . . . 15 12" set the time to UTC 3:12 p.m. maintaining the year, month and day.
  # If no arguments are passed, the time is set automatically.
  #
  # Args:
  #   $1 (optional): year
  #   $2 (optional): month
  #   $3 (optional): day
  #   $4 (optional): hour
  #   $5 (optional): minute
  #
  # Without Args:
  #   Set the time to auto
  if [ -z "$1" ]; then
    timedatectl set-ntp true
    echo RESTORED: "$(date +"%Y-%m-%d %H:%M:%S")"
    return 0
  fi

  if [[ $(timedatectl show --value --property NTPSynchronized) == "no" ]]; then
    timedatectl set-ntp false
  fi

  local year month day hour minute

  if [[ $1 && "$1" != "." ]]; then
    year=$1
  else
    year=$(date +%Y)
  fi

  if [[ $2 && "$2" != "." ]]; then
    month=$2
  else
    month=$(date +%m)
  fi

  if [[ $3 && "$3" != "." ]]; then
    day=$3
  else
    day=$(date +%d)
  fi

  if [[ $4 && "$4" != "." ]]; then

    # Fix UTC differences
    local timezone diff
    timezone=$(date +%Z)

    # - Get the absolute value of the difference
    diff=$(grep -Po "(?<=\+|-)[0-9]+" <<< "$timezone")

    # - When it's positive
    if grep -Pq "[+](?<=[0-9])*" <<< "$timezone"; then
      hour=$(($4 + $diff))

    # - When it's negative
    elif grep -Pq "[-](?<=[0-9])*" <<< "$timezone"; then
      hour=$(($4 - $diff))

    # - Whatever
    else
      hour=$4
    fi

  else
    hour=$(date +%H)
  fi

  if [[ $5 && "$5" != "." ]]; then
    minute=$5
  else
    minute=$(date +%M)
  fi

  echo BEFORE: "$(date +"%Y-%m-%d %H:%M:%S")"
  sudo date -s "$year-$month-$day $hour:$minute:$(date +%S)" >> /dev/null
  echo AFTER: "$(date +"%Y-%m-%d %H:%M:%S")"
}

function pk {
  # Terminate all processes related to a port
  #
  # Args:
  #   $1: port
  if [ -z "$1" ]; then
    echo Miss port
    return 1
  fi

  local processes
  processes=$(lsof -t -i:"$1")
  if [ -n "$processes" ]; then
    echo -e "$processes" | while read -r pid; do
      kill -9 "$pid"
    done
  else
    return 1
  fi
}


###############################################################################
# Python
###############################################################################


export PIPENV_VERBOSITY=-1
export WORKON_HOME=~/.Envs/Python
source ~/.local/bin/virtualenvwrapper.sh

function __check_py_virtual_env {
  if [[ $(python -c "import os; print(1 if os.getenv('VIRTUAL_ENV') else 0)") == "1" ]]; then
    return 0
  else
    return 1
  fi
}

function pyc {
  # Create a Python environment
  #
  # Args:
  #   $1: Python interpreter
  #   $2: env name
  if __check_py_virtual_env; then
    echo Deactivate the actual Python environment first
  fi

  if [ -z "$1" ]; then
    echo Miss Python interpreter and env name
    return 1
  fi

  if [ -z "$2" ]; then
    echo Miss env name
    return 1
  fi

  mkvirtualenv -p "$1" "$2"
  pip install virtualenvwrapper
  pyd
}

function pya {
  # Activate a Python environment
  #
  # Args:
  #   $1: env name
  if [ -z "$1" ]; then
    echo Miss env name
    return 1
  fi

  source $WORKON_HOME/"$1"/bin/activate
}

function pyl {
  # List all Python environments
  lsvirtualenv
}

function pyr {
  # Remove a Python environment
  #
  # Args:
  #   $1: env name
  if [ -z "$1" ]; then
    echo Miss env name
    return 1
  fi

  rmvirtualenv "$1"
}

function pyd {
  # Deactivate the present Python environment if any
  if __check_py_virtual_env; then
    deactivate
  fi
}


###############################################################################
# Deno and NodeJS
###############################################################################


source /usr/share/nvm/init-nvm.sh

function dd {
  # Use default Deno version
  dvm use v1.3.0
}

function nd {
  # Use the default NodeJS version
  nvm use node
}


###############################################################################
# Workspaces
###############################################################################


export WORKSPACE_H=~/Workspaces/H
export WORKSPACE_J=~/Workspaces/J
source ~/Workspaces/.hrc
source ~/Workspaces/.jrc
source ~/Workspaces/.crc

function __goto_clone {
  # Change to a clone of a repo
  #
  # Args:
  #   $1: repo base folder
  #   $2: repo name
  #   $3: clone number
  if [ -z "$3" ]; then
    return 1
  fi

  local clone head_path
  head_path="$1"/"$2"
  clone="$head_path"/"$3"/"$2"
  if [ -d "$clone" ]; then
    cd "$clone" || return
  else
    echo Making clone number "$3" using clone number 1
    mkdir "$head_path"/"$3"
    cp -r "$head_path"/1/"$2" "$clone"
    cd "$clone" || return
  fi
}

function clean {
  # Clean all workspaces envs
  #
  # It's mean all env vars and virtual envs set by the workspaces are removed
  __wh_cleanall
  __wj_cleanall
  pyd
  nd >> /dev/null
}

function wgc {
  # Clone git repository in the appropriated workspace
  #
  # Args:
  #   $1: "h" | "j": Clone for H or J workspace
  #   $2: repo user
  #   $3: repo name
  #   $4 (optional): base folder
  #
  # Example:
  #   wgc h jackfrued Python-100-Days learn
  if [ -z "$1" ]; then
    echo Miss the definition of workspace "( \"h\" | \"j\" )", repo user and repo name
    return 1
  fi

  if [ "$1" != h ] && [ "$1" != j ]; then
    echo Bad workspace
    return 1
  fi

  if [ -z "$2" ]; then
    echo Miss repo user and repo name
    return 1
  fi

  if [ -z "$3" ]; then
    echo Miss repo name
    return 1
  fi

  local workspace folder

  case $1 in
    h)
      workspace=H
      ;;
    j)
      workspace=J
      ;;
  esac

  if [ -n "$4" ]; then
    folder=~/Workspaces/"$workspace"/"$4"/"$3"/1
  else
    folder=~/Workspaces/"$workspace"/"$3"/1
  fi

  mkdir -p "$folder"
  git -C "$folder" clone git@github.com:"$2"/"$3".git
}
