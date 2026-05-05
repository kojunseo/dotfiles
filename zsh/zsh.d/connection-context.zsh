# Keep Powerlevel10k's SSH context aligned with the current terminal client.

typeset -g __DOTFILES_CONNECTION_CONTEXT_TMUX=
typeset -gi __DOTFILES_CONNECTION_CONTEXT_TS=-1
typeset -gi __DOTFILES_CONNECTION_CONTEXT_SSH=0

function _dotfiles_tmux_client_ssh() {
  local value

  value="$(tmux show-options -gqv @dotfiles_client_ssh 2>/dev/null)"
  case "$value" in
    0|1)
      print -r -- "$value"
      return 0
      ;;
  esac

  if tmux show-environment -q SSH_CONNECTION >/dev/null 2>&1 ||
     tmux show-environment -q SSH_CLIENT >/dev/null 2>&1 ||
     tmux show-environment -q SSH_TTY >/dev/null 2>&1; then
    print -r -- 1
  else
    print -r -- 0
  fi
}

function _dotfiles_update_connection_context() {
  emulate -L zsh

  local is_ssh=0
  if [[ -n "$TMUX" ]]; then
    if [[ "$__DOTFILES_CONNECTION_CONTEXT_TMUX" != "$TMUX" ||
          $__DOTFILES_CONNECTION_CONTEXT_TS -lt 0 ||
          $((SECONDS - __DOTFILES_CONNECTION_CONTEXT_TS)) -ge 1 ]]; then
      __DOTFILES_CONNECTION_CONTEXT_SSH="$(_dotfiles_tmux_client_ssh)"
      __DOTFILES_CONNECTION_CONTEXT_TMUX="$TMUX"
      __DOTFILES_CONNECTION_CONTEXT_TS=$SECONDS
    fi
    is_ssh=$__DOTFILES_CONNECTION_CONTEXT_SSH
  elif [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" || -n "$SSH_CONNECTION" ]]; then
    is_ssh=1
  fi

  typeset -gix P9K_SSH=$is_ssh
  typeset -gx _P9K_SSH_TTY=$TTY
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _dotfiles_update_connection_context
_dotfiles_update_connection_context
