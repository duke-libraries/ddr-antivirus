#!/bin/bash

# Start ClamAVA daemon
/etc/init.d/clamav-daemon start

exec "$@"
