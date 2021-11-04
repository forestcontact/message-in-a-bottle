#!/bin/bash
set -o xtrace
signal-desktop --no-sandbox & # run in the background
pid=$! # $! is the pid of the last run process
sleep 1
until [ "${window_id-}" ]; do # that substitution will be empty instead of an error if window_id is unset
    echo "waiting for window..."
    sleep 1
    # wmctrl -lp is a table of window_id, desktop number, pid, user, window title
    # for each line, awk prints the first column if the third column == pid
    window_id=$(wmctrl -lp | awk -v proc=$pid '{if ($3 == proc) print $1}') 
done
sleep 1 # wait for the qr code to show up
xwd -id $window_id | convert xwd:- jpg:- > qr.jpg # dump X window by id, turn it into a jpg
zbarimg -q qr.jpg | tee zbar_output | cut --delimiter ':' --fields 2- > signal_uri # extract the qr code and cut the leading 'QR-Code:'
echo -n "signal uri: " # don't add a newline
cat signal_uri
sleep 1d # sleep for a day
