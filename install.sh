#!/usr/bin/env bash
# Install script for wezterm-config (Linux/macOS/Windows Git Bash)
# Usage: curl -fsSL https://raw.githubusercontent.com/bzwang-phys/wezterm-config/main/install.sh | bash

set -euo pipefail

REPO="https://github.com/bzwang-phys/wezterm-config.git"

if [[ "${OSTYPE:-}" == "msys"* || "${OSTYPE:-}" == "cygwin"* || "${OSTYPE:-}" == "win32"* ]]; then
  # WezTerm looks under ~/.config/wezterm on Windows as well. Convert the
  # Windows-style USERPROFILE when this script is running in Git Bash/Cygwin.
  CONFIG_DIR="${USERPROFILE:-$HOME}/.config/wezterm"
  if command -v cygpath &>/dev/null; then
    CONFIG_DIR="$(cygpath -u "${CONFIG_DIR}")"
  fi
else
  CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/wezterm"
fi

echo "==> Installing wezterm config to ${CONFIG_DIR}"

# Check git is available
if ! command -v git &>/dev/null; then
  echo "Error: git is not installed." >&2
  exit 1
fi

# Backup existing config if it exists and is not this repo
if [ -d "${CONFIG_DIR}" ]; then
  if [ -d "${CONFIG_DIR}/.git" ]; then
    EXISTING_REMOTE=$(git -C "${CONFIG_DIR}" remote get-url origin 2>/dev/null || true)
    if [ "${EXISTING_REMOTE}" = "${REPO}" ]; then
      echo "==> Repo already cloned, pulling latest changes..."
      git -C "${CONFIG_DIR}" pull --rebase
      echo "==> Done!"
      exit 0
    fi
  fi
  BACKUP="${CONFIG_DIR}.bak.$(date +%s)"
  echo "==> Existing config found, backing up to ${BACKUP}"
  mv "${CONFIG_DIR}" "${BACKUP}"
fi

# Ensure parent directory exists
mkdir -p "$(dirname "${CONFIG_DIR}")"

# Clone
echo "==> Cloning ${REPO}..."
git clone "${REPO}" "${CONFIG_DIR}"

echo "==> Done! Restart wezterm to apply the new config."
