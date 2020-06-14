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


# ============================================================================
# Workspaces
# ============================================================================


# We use two workspaces, one for home works and other for the job works.
source ~/Workspace/.homerc
source ~/Workspace/.jobrc

cleanworkspace() {
  # Clean all workspaces
  # It's mean all virtual and variable environments setted by workspaces are removed
  wh_cleanall
  wj_cleanall
}
