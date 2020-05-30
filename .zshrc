# ============================================================================
# General config
# ============================================================================


# Load color scheme from pywal
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
    sudo date +%T -s $hour:$minutes:$seconds>>/dev/null
    echo AFTER: $(date +%T)
  else
    date +%T
  fi
}

bk() {
  # Run bk command and neofetch
  sh ~/.local/bin/bk.sh>>/dev/null $1
  clear
  neofetch
}

cow() {
  # A psychedelic cow that tells your fortune
  fortune | cowsay | lolcat
}

lolban() {
  # Print rainbow message with special ascii font
  if [ ! -z "$1" ]; then
    # Good fonts list:
    # ~/.local/share/figlet-fonts/3d.flf
    figlet $1 -f ~/.local/share/figlet-fonts/3d.flf | lolcat
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
