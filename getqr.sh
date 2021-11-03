#!/bin/bash
signal-desktop --no-sandbox &
pid=$!
sleep 1
until [ "${window_id-}"; do ]
    echo "waiting for window..."
    sleep 1
    window_id=$(wmctrl -lp | awk -v proc=$pid '{if ($3 == proc) print $1}')
done
xwd -id $window_id | convert xwd:- jpg:- > qr.jpg
zbarimg --quiet qr.jpg | cut --delimiter ':' --fields 2- > signal_uri
cat signal_uri
