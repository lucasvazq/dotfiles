# ============================================================================
# General config
# ============================================================================


# Start new terminals with tmux and add pywal color scheme
if ! { [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; } then
  # Prevent lose color scheme for news tmux sessions
  wal -R -e -q

  tmux
else
  # Add terminal color to alacritty
  cat ~/.cache/wal/sequences
fi

# Programs path
source ~/Programs/.programsrc

# Basic zsh config
export ZSH=~/.oh-my-zsh
ZSH_THEME="custom"
plugins=(git virtualenv shrink-path)
source $ZSH/oh-my-zsh.sh


# ============================================================================
# Tachyon Laser
# ============================================================================


bk() {
  # Change background and run neo function
  #
  # Args:
  #   $1 (optional): custom image
  sh change-background >> /dev/null $1
  clear
  neo
}

fav() {
  # Set preferred color schema
  wal -q --theme base16-materia
}

lolban() {
  # Print rainbow message with special ascii font
  #
  # Args:
  #   $1: Message
  if [ ! -z "$1" ]; then
    # Cool fonts list:
    # ~/.local/share/figlet-fonts/3d.flf
    figlet $@ -f ~/.local/share/figlet-fonts/3d.flf | lolcat
  else
    echo Miss message
  fi
}

cow() {
  # A psychedelic cow that tells your fortune
  fortune | cowsay -w -f three-eyes | lolcat
}

neo() {
  # Run custom neofetch config

  # If Ctrl+C is pressed we clear the screen
  trap clear INT

  neofetch

  # Return as success after press Ctrl+C
  return 0
}


# ============================================================================
# Productivity
# ============================================================================


# Alias for editor
alias ed=code

cud() {
  # Set UTC date
  # If not arguments passed, it restart datetime to default value
  #
  # Args:
  #   $1: Hours
  #   $2 (optional): Minutes
  #
  # Without Args:
  #   Restore default date
  if [ ! -z "$1" ]; then
    local utc_difference hour minutes seconds

    if [ timedatectl show --property NTPSynchronized | grep -Po '(?<=NTPSynchronized=).*' == 'no' ]; then
      timedatectl setq-ntp false
    fi

    utc_difference=3
    hour=$(($uno - $utc_difference))
    if [ ! -z "$2" ]; then
      minutes=$2
    else
      minutes=$(date +%M)
    fi
    seconds=$(date +%S)
  
    echo BEFORE: $(date +%T)
    sudo date +%T -s $hour:$minutes:$seconds >> /dev/null
    echo AFTER: $(date +%T)
  else
    timedatectl set-ntp true
  fi
}

wgc() {
  # Clone git repository in the appropiated workspace
  #
  # Args:
  #   $1: "h" | "j": Clone for Home or Job workspace
  #   $2: Repo
  if [ ! -z "$1" ]; then
    if [ ! -z "$2" ]; then
      case $1 in
        h)
          git -C ~/Workspace/Home clone $2
          ;;
        j)
          git -C ~/Workspace/Job clone $2
          ;;
        *)
          echo Bad workspace
          ;;
      esac
    else
      echo Miss Repo
    fi
  else
    echo Miss positional-only arguments. Workspace "( \"h\" | \"j\" )" and Repo
  fi
}


# ============================================================================
# Servers
# ============================================================================


drs() {
  # Run Django server
  #
  # Args:
  #   $1 (optional): Port
  if [ ! -z "$1" ]; then
    python manage.py runserver 127.0.0.1:$1
  else
    python manage.py runserver
  fi
}

hl() {
  # Run Heroku
  heroku local
}

ds() {
  # Open Django shell
  #
  # Args:
  #   $1 (optional): DB schema
  if [ ! -z "$1" ]; then
    python manage.py tenant_command shell --schema=$1
  else
  	python manage.py shell
  fi
}

hrs() {
  # Open Django shell in a remote Heroku App
  #
  # Args:
  #   $1: Heroku App
  #   $2 (optional): DB schema
  if [ ! -z "$1" ]; then
    if [ ! -z "$2" ]; then
      heroku run python manage.py tenant_command shell --schema=$2 -a $1
    else
      heroku run python manage.py shell -a $1
    fi
  else
    echo Miss positional-only arguments: Heroku App, Tenant (optional)
  fi
}

hrq() {
  # Run PostgreSQL CLI in a Heroku App
  #
  # Args:
  #   $1: Heroku App
  if [ ! -z "$1" ]; then
    heroku pg:psql -a $1
  else
    echo Miss Heroku App
  fi
}


# ============================================================================
# Python
# ============================================================================


export PIPENV_VERBOSITY=-1
export WORKON_HOME=~/.Envs/Python
source ~/.local/bin/virtualenvwrapper.sh

pyc() {
  # Create Python environment
  #
  # Args:
  #   $1: Python source
  #   $2: Env name
  if [ ! -z "$1" ]; then
    if [ ! -z "$2" ]; then
      mkvirtualenv --system-site-packages -p $1 $2
      pyd
    else
      echo Miss Env name
    fi
  else
    echo Miss positional-only arguments: Python source, Env name
  fi
}

pya() {
  # Activate Python environment
  #
  # Args:
  #   $1: Env name
  if [ ! -z "$1" ]; then
    source $WORKON_HOME/$1/bin/activate
  else
    echo Miss Env name
  fi
}

pyl() {
  # List all Python environments
  lsvirtualenv
}

pyr() {
  # Remove Python environment
  #
  # Args:
  #   $1: Env name
  if [ ! -z "$1" ]; then
    rmvirtualenv $1
  else
    echo Miss Env name
  fi
}

pyd() {
  # Deactivate Python environment
  if [[ $(python -c 'import sys; print ("1" if hasattr(sys, "real_prefix") else "0")') == "1" ]]; then
    deactivate
  fi
}


# ============================================================================
# Workspaces
# ============================================================================
# We use two workspaces, one for home works and other for the job works.


WORKSPACE_HOME=~/Workspace/Home
WORKSPACE_JOB=~/Workspace/Job
source ~/Workspace/.homerc
source ~/Workspace/.jobrc

cleanworkspaces() {
  # Clean all workspaces
  # It's mean all virtual and variable environments setted by workspaces are removed
  wh_cleanall
  wj_cleanall
}
