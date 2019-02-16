#!/bin/bash

# Client needs to know server conf :(
echo "TCPSocket 3310" > /etc/clamav/clamd.conf
echo "TCPAddr clamav" >> /etc/clamav/clamd.conf

wait-for-it clamav:3310 -t 30 -- "$@"
