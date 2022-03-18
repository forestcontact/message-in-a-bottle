Themes: running Signal Desktop without a phone on linux using X11-adjacent tretchery and signal-cli with improved semantics for solving captchas and getting QR codes

The general dance goes something like this:
```sh
# install stuff  to handle the signalcaptcha:// uri redirect
cp 00-signal-captcha.desktop /usr/share/applications/
cp save_signal_captcha /opt
update-desktop-database

# grab signal-cli to be the main device (you can also use an existing signal-cli, but graalvm native doesn't seem to work with updateProfile, which is required to join v2 groups)
VERSION=0.10.0
wget https://github.com/AsamK/signal-cli/releases/download/v"${VERSION}"/signal-cli-"${VERSION}".tar.gz | tar -xzf- -C /opt
ln -sf /opt/signal-cli-"${VERSION}"/bin/signal-cli /usr/local/bin/

# grab signal-desktop if you haven't already
# 1. Install our official public software signing key
curl https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor >> /usr/share/keyrings/signal-desktop-keyring.gpg
# 2. Add our repository to your list of repositories
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' >> /etc/apt/sources.list.d/signal-xenial.list
# 3. Update your package database and install signal
apt-get update && apt-get install -yy signal-desktop

# solve the captcha
xdg-open https://signalcaptchas.org/registration/generate.html
# if the protocol handler didn't work, manually copy the data and reformat it
# /opt/save_signal_captcha signalcaptcha://signal-recaptcha..."

# the rest of the owl
number={your phone number}
signal-cli -u $number register --captcha $(cat /tmp/captcha)
signal-cli -u $number verify {code that was texted to your number}
./getqr.sh &
sleep 5s
signal-cli -u $number addDevice --uri $(cat signal_uri)
```

If you don't care about docker and want desktop without a phone, try using the script above. Note that the captcha redirect will be overwritten whenever you update desktop.

To run desktop in docker with getqr.sh (but signal-cli outside), use run.sh. Pick a name for the saved image, and use `docker commit $(docker ps --latest --quiet) secondsignal:latest`, replacing "secondsignal" with the name you want to use for this account, to freeze it when you're done, so that you can keep your session state and keys

If you just want to run desktop in docker but don't care about signal, try only-desktop.Dockerfile. 

If you want to use testnet, try testnet.Dockerfile

Stay tuned for getting verification codes automatically and additional ways to package primary signal devices (desktop in chroots, automated compiling of .apks with different IDs, shelter(?))
