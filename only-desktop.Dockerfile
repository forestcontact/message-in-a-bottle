FROM ubuntu:latest
ENV DEBIAN_FRONTEND "noninteractive" 
RUN ln --symbolic --force --no-dereference /usr/share/zoneinfo/EST /etc/localtime && \
	echo "EST" > /etc/timezone && apt-get update && \
	apt-get install -yy curl gpg #zbar-tools imagemagick x11-apps wmctrl

# 1. Install our official public software signing key 
RUN curl https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > /usr/share/keyrings/signal-desktop-keyring.gpg && \
    # 2. Add our repository to your list of repositories
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' >> /etc/apt/sources.list.d/signal-xenial.list && \
    # 3. Update your package database and install signal
    apt-get update && apt-get install -yy signal-desktop
