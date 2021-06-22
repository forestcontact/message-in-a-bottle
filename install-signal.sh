#!/bin/bash
set -o pipefail -o xtrace -o errexit
# 1. Install our official public software signing key
curl https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
cat signal-desktop-keyring.gpg |  tee -a /usr/share/keyrings/signal-desktop-keyring.gpg  > /dev/null

# 2. Add our repository to your list of repositories
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' | tee -a /etc/apt/sources.list.d/signal-xenial.list

# 3. Update your package database and install signal
DEBIAN_FRONTEND="noninteractive" apt update && apt install -yy signal-desktop
