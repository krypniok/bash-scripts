#!/bin/bash
maim -g "$(slop -f '%g')" | xclip -selection clipboard -t image/png

