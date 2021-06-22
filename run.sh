#!/bin/bash
xhost +local:docker
sudo docker run --net=host --env="DISPLAY" --volume="$HOME/.Xauthority:/root/.Xauthority:rw" -it secondsignal signal-desktop --no-sandbox               
