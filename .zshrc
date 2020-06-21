# ============================================================================
# General config
# ============================================================================


# Start new terminals with tmux
if ! { [ "$TERM" = "screen" ] && [ -n "$TMUX" ]; } then
  # Prevent lose color scheme for new tmux sessions
  wal -R -e -q

  tmux
fi

# Load pywal color scheme for new terminals
cat ~/.cache/wal/sequences

# Basic zsh config
export ZSH=~/.oh-my-zsh
ZSH_THEME="custom"
plugins=(git virtualenv shrink-path)
source $ZSH/oh-my-zsh.sh

# Alias for editor
alias ed=code

cud() {
  # Set UTC date
  # If not arguments passed, it restart datetime to default value
  # Args:
  #   $1: Hour
  #   $2 (optional): Minutes
  if [ ! -z "$1" ]; then
    local utc_difference hour minutes seconds
    echo BEFORE: $(date +%T)
    utc_difference=3
    hour="$(($1 - $utc_difference))"
    if [ ! -z "$2" ]; then
      minutes=$2
    else
      minutes=$(date +%M)
    fi
    seconds=$(date +%S)
    sudo date +%T -s $hour:$minutes:$seconds >> /dev/null
    echo AFTER: $(date +%T)
  else
    date +%T
  fi
}

pk() {
  # Port kill
  # Args:
  #   $1: Port
  if [ ! -z "$1" ]; then
    kill -9 $(lsof -t -i:$1)
  else
    echo Miss port
  fi
}

neo() {
  echo neo
  # Run custom neofetch config

  # If Ctrl+C is pressed we clear the screen
  trap clear INT

  neofetch

  # Return as success after press Ctrl+C
  return 0
}

bk() {
  # Change background and run neo function
  # Args:
  #   $1 (optional): Background image
  sh change-background >> /dev/null $1
  clear
  neo
}

fav() {
  # Set preferred color schema
  wal -q --theme base16-materia
}

cow() {
  # A psychedelic cow that tells your fortune
  fortune | cowsay | lolcat
}

lolban() {
  # Print rainbow message with special ascii font
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


# ============================================================================
# Python
# ============================================================================


export WORKON_HOME=~/.Envs/Python
source ~/.local/bin/virtualenvwrapper.sh

deactivate_python() {
  # Function used to clean python virtual environments
  # https://stackoverflow.com/a/15454916/10712525
  local python_env
  python_env=$(python -c 'import sys; print ("1" if hasattr(sys, "real_prefix") else "0")')
  if [[ python_env == "1" ]]; then
    deactivate
  fi
}

drs() {
  # Run Django server
  # Args:
  #   $1 (optional): Port
  if [ ! -z "$1" ]; then
    python manage.py runserver 127.0.0.1:$1
  else
    python manage.py runserver
  fi
}

hl() {
  # Heroku local
  heroku local
}

dsh() {
  # Django shell
  # Args:
  #   $1 (optional): Tenant schema, from django-tenants package
  #     https://github.com/django-tenants/django-tenants
  if [ ! -z "$1" ]; then
    python manage.py tenant_command shell --schema=$1
  else
  	python manage.py shell
  fi
}

hrs() {
  # Heroku remote shell
  # Args:
  #   $1: Review app name
  #   $2 (optional): Tenant schema, from django-tenants package
  #     https://github.com/django-tenants/django-tenants
  if [ ! -z "$1" ]; then
    if [ ! -z "$2" ]; then
      heroku run python manage.py tenant_command shell --schema=$2 -a $1
    else
      heroku run python manage.py shell -a $1
    fi
  else
    echo Miss positional-only arguments: Review app, Tenant (optional)
  fi
}
