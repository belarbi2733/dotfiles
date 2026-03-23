#!/bin/bash
# Get the 10.0.x.x IP address of this machine
hostname -I | tr ' ' '\n' | grep '^10\.0\.' | head -1
