#!/bin/sh
xhost +local:docker
docker build -t secondsignal . && \
    sudo docker run --net=host --env="DISPLAY" --volume="$HOME/.Xauthority:/root/.Xauthority:rw" -it secondsignal ./getqr.sh
#signal-cli addDevice --uri <uri from the above>
