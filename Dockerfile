FROM ubuntu:latest
ENV DEBIAN_FRONTEND "noninteractive" 
RUN ln --symbolic --force --no-dereference /usr/share/zoneinfo/EST /etc/localtime && \
	echo "EST" > /etc/timezone && apt-get update && \
	apt-get install -yy curl gpg zbar-tools imagemagick x11-apps wmctrl
COPY ./install-signal.sh ./getqr.sh ./
# 1. Install our official public software signing key
RUN  ./install-signal.sh


