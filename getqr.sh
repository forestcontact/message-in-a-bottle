#!/bin/sh -x
signal-desktop --no-sandbox & # run in the background
pid=$! # $! is the pid of the last run process
sleep 2

# wmctrl -lp is a table of window_id, desktop number, pid, user, window title
while window_id=$(wmctrl -lp | awk -v proc="$pid" '{if ($3 == proc) {print $1; exit 1}'); do
    echo "waiting for window..."
    sleep 1
done

sleep 1 # wait for the qr code to show up
printf "signal uri: "
# dump X window by id, extract the qr code and remove the leading 'QR-Code:'
xwd -id "$window_id" | tee qr.xwd | zbarimg -q xwd:- | tee zbar_output | cut -d: -f2- | tee signal_uri
sleep 1d # sleep for a day
