FROM ubuntu:latest
ENV DEBIAN_FRONTEND "noninteractive" 
RUN ln --symbolic --force --no-dereference /usr/share/zoneinfo/EST /etc/localtime  && echo "EST" > /etc/timezone && apt-get update && apt-get install -yy curl gpg
COPY ./install-signal.sh .
# 1. Install our official public software signing key
RUN  ./install-signal.sh


