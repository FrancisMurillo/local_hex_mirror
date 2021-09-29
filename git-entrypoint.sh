#!/bin/bash

echo "Creating fcgiwrap socket"
rm -f /var/run/fcgiwrap.sock-1
fcgiwrap -s unix:/var/run/fcgiwrap.sock-1 &

echo "Waiting on fcgiwrap socket"
sleep 1
chown nginx:nginx /var/run/fcgiwrap.sock-1
chmod 777 /var/run/fcgiwrap.sock-1

echo "Starting nginx"
nginx -g 'daemon off;'
