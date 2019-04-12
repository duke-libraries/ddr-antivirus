#!/bin/bash
wait-for-it clamav:3310 -t 60 -- "$@"
