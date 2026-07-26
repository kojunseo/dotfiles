#!/usr/bin/env bash

set -euo pipefail

# Keep the plugin revision pinned so repeated dotfiles installations are
# deterministic.
HERDR_PLUGIN_SOURCE="smarzban/herdr-file-viewer"
HERDR_PLUGIN_REVISION="96fcc0a2bdd2727ec88c38f8c8806f97b7ca0ea0"
HERDR_LOCAL_BINARY="${HOME}/.local/bin/herdr"

find_herdr() {
  if [[ -x "${HERDR_LOCAL_BINARY}" ]]; then
    printf '%s\n' "${HERDR_LOCAL_BINARY}"
  else
    command -v herdr || true
  fi
}

install_herdr() {
  local herdr_bin

  herdr_bin="$(find_herdr)"
  if [[ -n "${herdr_bin}" ]]; then
    echo "Herdr already installed: $("${herdr_bin}" --version)"
    return
  fi

  case "$(uname)" in
    Darwin | Linux)
      curl -fsSL https://herdr.dev/install.sh | sh
      ;;
    *)
      echo "Skipping Herdr installation: unsupported platform $(uname)." >&2
      return 1
      ;;
  esac
}

install_file_viewer() {
  local herdr_bin="$1"
  local plugin_state

  plugin_state="$("${herdr_bin}" plugin list --plugin herdr-file-viewer --json 2>/dev/null || true)"
  if [[ "${plugin_state}" == *"\"resolved_commit\":\"${HERDR_PLUGIN_REVISION}\""* ]] &&
    [[ "${plugin_state}" == *'"enabled":true'* ]]; then
    echo "Herdr file viewer already installed at ${HERDR_PLUGIN_REVISION}."
    return
  fi

  "${herdr_bin}" plugin install "${HERDR_PLUGIN_SOURCE}" \
    --ref "${HERDR_PLUGIN_REVISION}" \
    --yes
  "${herdr_bin}" plugin enable herdr-file-viewer
}

reload_herdr_config() {
  local herdr_bin="$1"

  if "${herdr_bin}" config --help 2>&1 | grep -q 'check'; then
    "${herdr_bin}" config check
  fi
  if "${herdr_bin}" status server >/dev/null 2>&1; then
    "${herdr_bin}" server reload-config
    echo "Reloaded Herdr config: ${HOME}/.config/herdr/config.toml"
  else
    echo "Herdr config will be loaded when the server starts."
  fi
}

main() {
  local herdr_bin

  install_herdr
  herdr_bin="$(find_herdr)"
  if [[ -z "${herdr_bin}" ]]; then
    echo "Herdr installation completed, but its binary was not found." >&2
    return 1
  fi

  "${herdr_bin}" --version
  install_file_viewer "${herdr_bin}"
  reload_herdr_config "${herdr_bin}"
}

main "$@"
