#!/usr/bin/env bash
# vim: set expandtab ts=2 sts=2 sw=2:
set -euo pipefail

# Install the latest pman binary from GitHub releases, picking the right
# archive for the current OS/architecture.

INSTALL_PMAN=1
INSTALL_PQM=1
if command -v pman >/dev/null 2>&1; then
  echo "pman already installed at: $(command -v pman)"
  INSTALL_PMAN=0
fi
if command -v pqm >/dev/null 2>&1; then
  echo "pqm already installed at: $(command -v pqm)"
  INSTALL_PQM=0
fi
if [[ "${INSTALL_PMAN}" -eq 0 && "${INSTALL_PQM}" -eq 0 ]]; then
  echo "pman/pqm already installed; skipping."
  exit 0
fi

BASE_URL="https://github.com/kojunseo/pman/releases/latest/download"
OS="$(uname -s)"
ARCH="$(uname -m)"
TMPDIR="$(mktemp -d /tmp/pman.XXXXXX)"
cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT

echo "Installing pman/pqm for ${OS}/${ARCH} ..."

case "$OS" in
  Darwin)
    case "$ARCH" in
      arm64|aarch64) DOWNLOAD="${BASE_URL}/pman_Darwin_arm64.tar.gz" ;;
      x86_64|amd64) DOWNLOAD="${BASE_URL}/pman_Darwin_x86_64.tar.gz" ;;
      *) echo "pman: unsupported macOS architecture ($ARCH), skipping."; exit 0 ;;
    esac
    ;;
  Linux)
    case "$ARCH" in
      x86_64|amd64) DOWNLOAD="${BASE_URL}/pman_Linux_x86_64.tar.gz" ;;
      *) echo "pman: no prebuilt binary for Linux ${ARCH}, skipping."; exit 0 ;;
    esac
    ;;
  *)
    echo "pman: unsupported OS (${OS}), skipping."
    exit 0
    ;;
esac

if ! command -v curl >/dev/null 2>&1; then
  echo "pman: curl is required to download binaries." >&2
  exit 1
fi

echo "Downloading from: ${DOWNLOAD}"
curl -fL "${DOWNLOAD}" -o "${TMPDIR}/pman.tar.gz"

tar -xvzf "${TMPDIR}/pman.tar.gz" -C "${TMPDIR}"
if [[ "${INSTALL_PMAN}" -eq 1 && ! -f "${TMPDIR}/pman" ]]; then
  echo "pman: extracted archive did not contain the binary." >&2
  exit 1
fi
if [[ "${INSTALL_PQM}" -eq 1 && ! -f "${TMPDIR}/pqm" ]]; then
  echo "pqm: extracted archive did not contain the binary; skipping pqm install."
  INSTALL_PQM=0
fi

BINARIES=()
if [[ "${INSTALL_PMAN}" -eq 1 ]]; then
  BINARIES+=(pman)
fi
if [[ "${INSTALL_PQM}" -eq 1 ]]; then
  BINARIES+=(pqm)
fi
if [[ "${#BINARIES[@]}" -eq 0 ]]; then
  echo "Nothing to install."
  exit 0
fi

DEST_SYSTEM_DIR="/usr/local/bin"
DEST_USER_DIR="${HOME}/.local/bin"
mkdir -p "${DEST_USER_DIR}"

install_binaries() {
  local dest_dir="$1"
  for bin in "${BINARIES[@]}"; do
    install -m 755 "${TMPDIR}/${bin}" "${dest_dir}/${bin}"
  done
}

installed_dir=""
if [[ -w "${DEST_SYSTEM_DIR}" ]]; then
  install_binaries "${DEST_SYSTEM_DIR}"
  installed_dir="${DEST_SYSTEM_DIR}"
elif command -v sudo >/dev/null 2>&1; then
  sudo_failed=""
  for bin in "${BINARIES[@]}"; do
    if ! sudo install -m 755 "${TMPDIR}/${bin}" "${DEST_SYSTEM_DIR}/${bin}"; then
      sudo_failed="true"
      break
    fi
  done
  if [[ -z "${sudo_failed}" ]]; then
    installed_dir="${DEST_SYSTEM_DIR}"
  else
    echo "pman: sudo install to /usr/local/bin failed; falling back to user install."
  fi
else
  echo "pman: no permission to write to /usr/local/bin; installing to ${DEST_USER_DIR}"
fi

if [[ -z "${installed_dir}" ]]; then
  install_binaries "${DEST_USER_DIR}"
  installed_dir="${DEST_USER_DIR}"
  echo "pman installed to user bin; ensure ${HOME}/.local/bin is in PATH."
fi

echo "Installed ${BINARIES[*]} to: ${installed_dir}"
