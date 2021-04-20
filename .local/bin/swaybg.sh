#!/bin/bash

swaymsg "output '*' bg $(find $HOME/backgrounds -type f | shuf -n 1) fill"
