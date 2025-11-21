###############################################################################
# Shell.
###############################################################################

# Zsh.
# - General.
setopt NO_BEEP
# - Completion.
zstyle :compinstall filename "${HOME}/.zshrc"
autoload -Uz compinit
compinit
# - History.
HISTFILE="${HOME}/.config/.histfile"
HISTSIZE=1000
SAVEHIST=1000

# Starship.
function _set_starship_config {
    local git_root
    git_root=$(command git -C "$PWD" rev-parse --show-toplevel 2>/dev/null || echo)
    if [[ -n "$git_root" && "$git_root" == "${HOME}" ]]; then
        export STARSHIP_CONFIG="${HOME}/.config/starship-ignore-git.toml"
    else
        export STARSHIP_CONFIG="${HOME}/.config/starship.toml"
    fi
}

precmd_functions=(_set_starship_config "${precmd_functions[@]}")
eval "$(starship init zsh)"

# Lines Separator.
_START=true
_RESET="\033[0m"
_BOLD="\033[1m"
_COLOR_BLACK="\033[30m"
_COLOR_SEPARATOR_FIRST_TIME="\033[48;5;231m"
_COLOR_SEPARATOR="\033[48;5;146m"

function _separator {
    local string background newline
    string="${1}"
    background="${2}"
    newline="${3:-false}"

    if [[ "${_START}" == "true" ]]; then
        _START=false
    else
        echo
    fi

    local text width
    if [[ "${newline}" == "false" ]]; then
        text="${_COLOR_BLACK}"
    fi
    width=$(($(tput cols)-${#string}))
    echo -e "${_BOLD}${background}${text}${string}$(printf '%.0s-' $(seq 1 $width))${_RESET}"

    if [[ "${newline}" == "true" ]]; then
        echo
    fi
}

function precmd {
    if [[ "${_START}" == "true" ]]; then
        _separator "> Init" "${_COLOR_SEPARATOR_FIRST_TIME}"
    else
        _separator "> Execute Command" "${_COLOR_SEPARATOR}"
    fi
}

function preexec {
    _separator "> Output" "${_COLOR_SEPARATOR}" true
}

###############################################################################
# Bindings.
###############################################################################

WORDCHARS=""

bindkey -e
#       Action                              Key
#       ------------------------------------------------
bindkey "^[[H" beginning-of-line    # Home
bindkey "^[[F" end-of-line          # End
bindkey "^[[5~" up-line-or-search   # Page Up
bindkey "^[[6~" down-line-or-search # Page Down
bindkey "^[[1;5D" backward-word     # Ctrl + Left Arrow
bindkey "^[[1;5C" forward-word      # Ctrl + Right Arrow
bindkey "^[[3~" delete-char         # Supr
bindkey "^[[3;5~" kill-word         # Ctrl + Delete
bindkey "^W" backward-kill-word     # Ctrl + Backspace

###############################################################################
# Alias.
###############################################################################

alias code="code --password-store=gnome-libsecret"
alias grep="grep --color=auto"
alias rm="trash"

function curl {
    local output status_code json
    output="$(/usr/bin/curl "$@" -sS -w "\nstatus: %{http_code}" -H "Content-Type: application/json")"
    status_code=$(echo "${output}" | tail -n1)
    json=$(echo "${output}" | sed '$d')
    if echo "${json}" | jq empty 2>/dev/null; then
        echo "${json}" | jq .
        echo "${status_code}"
    else
        echo "${output}"
    fi
}

function ls {
    (
        echo -e "USER\tGROUP\tOTHER\tNAME\tSIZE\tMODIFIED"
        LC_COLLATE=C /usr/bin/ls -lh --almost-all --full-time "$@" | awk '
            function color(code, text) {
                return "\033[" code "m" text "\033[0m"
            }
            NF > 8 {
                # Format Permissions.
                local file_type perm user_perm group_perm other_perm user_perm_str group_perm_str other_perm_str;
                file_type=substr($1, 1, 1);
                perm = substr($1, 2);
                user_perm = substr(perm, 1, 3);
                group_perm = substr(perm, 4, 3);
                other_perm = substr(perm, 7, 3);
                group_perm_str = (group_perm == "---") ? "-" : gensub(/-/, "", "g", group_perm);
                other_perm_str = (other_perm == "---") ? "-" : gensub(/-/, "", "g", other_perm);

                if (user_perm == "r--") {
                    # Color the "r" perm in red if user has only read permission.
                    user_perm_str = color("31", "r");
                } else {
                    user_perm_str = (user_perm == "---") ? "-" : gensub(/-/, "", "g", user_perm);
                }

                # Combine permission owner with their permissions.
                local user_col group_col other_col;
                user_col = $3 " " user_perm_str;
                group_col = $4 " " group_perm_str;
                other_col = "other " other_perm_str;

                # Handle filename (including multi-word names).
                local name;
                name = $9;
                for (i = 10; i <= NF; i++) name = name " " $i;

                # Append "/" to directories.
                if (file_type == "d") name = name "/";

                # Color the NAME column based on file type.
                if (file_type == "d") {
                    name = color("34", name);
                } else if (file_type == "l") {
                    name = color("36", name);
                } else {
                    name = color("32", name);
                }

                # Size
                local size;
                size = $5;

                # Modification date
                local date time datetime;
                date = $6;
                time = gensub(/\.[0-9]+$/, "", "g", $7);
                datetime = date " " time;

                print user_col "\t" group_col "\t" other_col "\t" name "\t" size "\t" datetime;
            }
        '
    ) | column -t -s $'\t'
}

docker() {
    local first_argument
    first_argument="$1"

    if [[ "${first_argument}" == "ps" && "$#" -eq 1 ]]; then
        shift
        command docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    else
        command docker "$@"
    fi
}
