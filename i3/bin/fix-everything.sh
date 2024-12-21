#!/usr/bin/env bash

echo 'Fixing everything...'
i3-setup-power-and-lock-management.sh
i3-initialize-outputs.sh
set-keyboard-layout.sh
switch-audio-output --auto
