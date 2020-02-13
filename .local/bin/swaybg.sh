#!/bin/bash

swaymsg "output '*' bg $(find /usr/share/backgrounds/mine -type f | shuf -n 1) fill"
