#!/bin/bash
xhost +local:docker
sudo docker run --net=host --env="DISPLAY" --volume="$HOME/.Xauthority:/root/.Xauthority:rw" -it secondsignal signal-desktop --no-sandbox               
# save the qr code
# zbarimg --quiet $qr_file | cut --delimiter ':' --fields 2- > signal_uri
# ./signal-cli addDevice --uri $(cat signal_uri)
