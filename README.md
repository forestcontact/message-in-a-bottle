```
# install stuff  to handle the signalcaptcha:// uri redirect
cp signal-captcha.desktop /usr/share/applications
cp save_signal_captcha /opt
echo "x-scheme-handler/signalcaptcha=signalcaptcha.desktop;" >> /usr/share/applications/mimeinfo.cache

# grab signal-cli to be the main device (you can also use an existing signal-cli, but graalvm native doesn't seem to work with updateProfile, which is required to join v2 groups)
export VERSION=0.8.4
wget https://github.com/AsamK/signal-cli/releases/download/v"${VERSION}"/signal-cli-"${VERSION}".tar.gz
sudo tar xf signal-cli-"${VERSION}".tar.gz -C /opt
sudo ln -sf /opt/signal-cli-"${VERSION}"/bin/signal-cli /usr/local/bin/


# grab signal-desktop if you haven't already
# 1. Install our official public software signing key
curl https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor |  tee -a /usr/share/keyrings/signal-desktop-keyring.gpg  > /dev/null && \
# 2. Add our repository to your list of repositories
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' | tee -a /etc/apt/sources.list.d/signal-xenial.list && \
# 3. Update your package database and install signal
sudo apt update && sudo apt install -yy signal-desktop

# solve the captcha
xdg-open https://signalcaptchas.org/registration/generate.html

# the rest of the owl
export number={your number}
signal-cli -u $number register --captcha $(cat /tmp/captcha)
signal-cli -u $number verify {code that was texted to your number}
signal-cli -u $number addDevice --uri $(./getqr.sh)
```

to run in docker instead, use run.sh. pick a name for the saved image, and use `docker commit $(docker ps --latest --quiet)` to freeze it when you're done, so that you can keep your session state and keys
