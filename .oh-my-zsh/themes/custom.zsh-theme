prompt_root() {
  if [[ $UID -eq 0 ]]; then
    echo -n "%{%F{yellow}%}⚡%{%F{default}%} "
  fi
}

prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    echo -n "(`basename $virtualenv_path`) "
  fi
}

prompt_dir() {
  echo -n "%{%F{blue}%}$(shrink_path -f)%{%F{default}%}"
}

prompt_git() {
  (( $+commands[git] )) || return
  if [[ "$(git config --get oh-my-zsh.hide-status 2>/dev/null)" = 1 ]]; then
    return
  fi
  local PL_BRANCH_CHAR
  () {
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"

    # 
    PL_BRANCH_CHAR=$'\ue0a0'
  }
  local ref dirty mode repo_path

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    repo_path=$(git rev-parse --git-dir 2>/dev/null)
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
    if [[ -n $dirty ]]; then
      echo -n " %{%F{green}%}"
    else
      echo -n " %{%F{yellow}%}"
    fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:*' unstagedstr '●'
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats ' %u%c'
    vcs_info
    echo -n "${ref/refs\/heads\//$PL_BRANCH_CHAR }${vcs_info_msg_0_%% }${mode}"
  fi
  echo -n "%{%F{default}%} "
}

prompt_end() {
  if [[ $RETVAL -ne 0 ]]; then
    echo -n "%{%F{red}%}✘%{%F{default}%} "
  else
    echo -n "➜ "
  fi
}

build_prompt() {
  RETVAL=$?
  prompt_root
  prompt_virtualenv
  prompt_dir
  prompt_git
  prompt_end
}
PROMPT='%{%f%b%k%}$(build_prompt)'
