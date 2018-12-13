#!/bin/bash

function print_help_msg() {
    cat <<-EOF
sflip's dotfiles - setup different DPI modes
This script is a dirty hack to switch between regular and HiDPI settings.

Usage: setup-dpi.sh [--high|--normal]

    OPTIONS:
    -h | --help             Don't do anything, just print this help message.
    -H | --high             Apply HiDPI settings everywhere.
    -R | --regular          Apply regular DPI settings everywhere.
    -f | --force            Disregard current settings.

EOF
}


# CONFIG
X_SERVER_DPI_REGULAR=128
X_SERVER_DPI_HIGH=320
POLYBAR_DPI_REGULAR=170
POLYBAR_DPI_HIGH=300
FONT_SIZE_REGULAR=11
FONT_SIZE_HIGH=28
GOOGLE_CHROME_SCALE_FACTOR_REGULAR=1
GOOGLE_CHROME_SCALE_FACTOR_HIGH=3.0
FIREFOX_SCALE_FACTOR_REGULAR=1
FIREFOX_SCALE_FACTOR_HIGH=3.0


set -e

# cd into directory of this very script
# http://stackoverflow.com/a/246128/4568748
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR" || exit 1

# get arguments
TEMP=$(getopt -o hHRf --long help,high,regular,force -n 'test.sh' -- "$@")
eval set -- "$TEMP"
while true ; do
    case "$1" in
        -h|--help)              print_help_msg; exit 0 ;;
        -H|--high)              MODE=high; shift ;;
        -R|--regular)           MODE=regular ; shift ;;
        -f|--force)             FORCE=true ; shift ;;
        --) shift ; break ;;
        *) echo 'Internal error!' ; exit 1 ;;
    esac
done

if [[ -z "${MODE}" ]]; then
  print_help_msg; exit 0
fi

function change_x_server_dpi() {
  local DPI="$1"
  local FILE="$HOME/.Xresources"
  sed -E -i --follow-symlinks -- "s/^(Xft\\.dpi:) (.+)/\\1 ${DPI}/" "${FILE}"
  xrdb -merge "${FILE}"
}

function change_rofi_font_size() {
  local FONT_SIZE="$1"
  local FILE="$HOME/.config/rofi/config"
  sed -E -i --follow-symlinks -- "s/^(rofi.font: .+) (.+)/\\1 ${FONT_SIZE}/" "${FILE}"
  xrdb -merge "${FILE}"
}

function switch_firefox_dpi() {
  local DPI="$1"
  local PROFILE_DIR=$(find ~/.mozilla/firefox/ -type d -name '*.default')
  local FILE="${PROFILE_DIR}/user.js"
  touch "${FILE}"
  if grep -q -- 'layout.css.devPixelsPerPx' "${FILE}"; then
    sed -E -i --follow-symlinks -- "s/^(user_pref\\(\"layout.css.devPixelsPerPx\", \")(.+)(\"\\);)/\\1${DPI}\3/" "${FILE}"
  else
    echo "user_pref(\"layout.css.devPixelsPerPx\", \"${DPI}\");" >> "${FILE}"
  fi
  pkill -x firefox && nohup firefox & # restart
}

function switch_google_chrome_scale_factor() {
  local FACTOR="$1"
  local FILE="$HOME/.config/chrome-flags.conf"
  touch "${FILE}"
  if grep -q -- '--force-device-scale-factor' "${FILE}"; then
    sed -E -i --follow-symlinks -- "s/^(--force-device-scale-factor=)(.+)/\\1${FACTOR}/" "${FILE}"
  else
    echo "--force-device-scale-factor=${FACTOR}" >> "${FILE}"
  fi
  pkill -x chrome && nohup google-chrome-stable & # restart
}

function switch_chromium_scale_factor() {
  local FACTOR="$1"
  local FILE="$HOME/.config/chromium-flags.conf"
  touch "${FILE}"
  if grep -q -- '--force-device-scale-factor' "${FILE}"; then
    sed -E -i --follow-symlinks -- "s/^(--force-device-scale-factor=)(.+)/\\1${FACTOR}/" "${FILE}"
  else
    echo "--force-device-scale-factor=${FACTOR}" >> "${FILE}"
  fi
  pkill -x chromium && nohup chromium & # restart
}

function switch_polybar_dpi() {
  local DPI="$1"
  local FILE="$HOME/.config/polybar/config"
  sed -E -i --follow-symlinks -- "s/^dpi = .*/dpi = ${DPI}/" "${FILE}"
  "$HOME/.i3/bin/i3-polybar.sh" restart || true
}

function switch_to_hidpi() {
  echo "Switching to HiDPI..."
  change_x_server_dpi "${X_SERVER_DPI_HIGH}"
  change_rofi_font_size "${FONT_SIZE_HIGH}"
  switch_firefox_dpi "${FIREFOX_SCALE_FACTOR_HIGH}"
  switch_google_chrome_scale_factor "${GOOGLE_CHROME_SCALE_FACTOR_HIGH}"
  switch_chromium_scale_factor "${GOOGLE_CHROME_SCALE_FACTOR_HIGH}"
  switch_polybar_dpi "${POLYBAR_DPI_HIGH}"
  i3-msg restart | exit 0
}

function switch_to_regular_dpi() {
  echo "Switching to regular DPI..."
  change_x_server_dpi "${X_SERVER_DPI_REGULAR}"
  change_rofi_font_size "${FONT_SIZE_REGULAR}"
  switch_firefox_dpi "${FIREFOX_SCALE_FACTOR_REGULAR}"
  switch_google_chrome_scale_factor "${GOOGLE_CHROME_SCALE_FACTOR_REGULAR}"
  switch_chromium_scale_factor "${GOOGLE_CHROME_SCALE_FACTOR_REGULAR}"
  switch_polybar_dpi "${POLYBAR_DPI_REGULAR}"
  i3-msg restart | exit 0
}


HIDPI_ENABLED="./.HiDPI"

if [[ ( ! -f "${HIDPI_ENABLED}" || -n "${FORCE}" ) && "${MODE}" = high ]]; then
  switch_to_hidpi
  touch "${HIDPI_ENABLED}"
elif [[ ( -f "${HIDPI_ENABLED}" || -n "${FORCE}" ) && "${MODE}" = regular ]]; then
  switch_to_regular_dpi
  rm -f "${HIDPI_ENABLED}"
else
  echo "Nothing to do..."
fi

