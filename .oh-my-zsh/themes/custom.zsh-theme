#!/bin/sh


function __prompt_virtualenv {
  if [[ -n $VIRTUAL_ENV && -n $VIRTUAL_ENV_DISABLE_PROMPT ]]; then
    echo -n "[$(basename "$VIRTUAL_ENV")] "
  fi
}

function __prompt_dir {
  echo -n "%{%F{blue}%}$(shrink_path -f)%{%F{default}%}"
}

function __prompt_git {
  (( $+commands[git] )) || return

  if [[ "$(git config --get oh-my-zsh.hide-status 2> /dev/null)" = 1 ]]; then
    return
  fi

  if $(git rev-parse --is-inside-work-tree > /dev/null 2>&1); then
    local dirty ref mode repo_path

    dirty=$(parse_git_dirty)
    if [[ -n $dirty ]]; then
      echo -n " %{%F{green}%}"
    else
      echo -n " %{%F{yellow}%}"
    fi

    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"

    repo_path=$(git rev-parse --git-dir 2> /dev/null)
    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    setopt promptsubst
    autoload -Uz vcs_info
    zstyle ":vcs_info:*" enable git
    zstyle ":vcs_info:*" get-revision true
    zstyle ":vcs_info:*" check-for-changes true
    zstyle ":vcs_info:*" stagedstr "✚"
    zstyle ":vcs_info:*" unstagedstr "●"
    zstyle ":vcs_info:*" formats " %u%c "
    zstyle ":vcs_info:*" actionformats " %u%c "
    vcs_info

    echo -n "${ref/refs\/heads\//}${vcs_info_msg_0_%% }${mode}"
  fi

  echo -n "%{%F{default}%} "
}

function __prompt_end {
  if [[ $RETVAL -ne 0 ]]; then
    echo -n "%{%F{red}%}x%{%F{default}%} "
  else
    echo -n "➜ "
  fi
}

function __build_prompt {
  RETVAL=$?
  __prompt_virtualenv
  __prompt_dir
  __prompt_git
  __prompt_end
}
export PROMPT='%{%f%b%k%}$(__build_prompt)'
