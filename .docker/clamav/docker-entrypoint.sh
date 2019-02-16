#!/bin/bash

# Start ClamAV daemon
/usr/sbin/clamd -F -c /etc/clamd.d/docker.conf

exec "$@"
