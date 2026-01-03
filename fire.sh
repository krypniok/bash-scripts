#!/bin/bash

draw_fire_fg_rgb() {
  local x=$1 y=$2 maxw=$3 h=$4

  # RGB-Flammenspektrum (rot → gelb)
  local reds=(255 255 255 255 240 220)
  local greens=(0 80 140 200 200 180)
  local blues=(0 0 0 0 20 40)
  local chars=( "▄" "█" "▀" )

  for ((row=0; row<h; row++)); do
    local w=$(( (maxw * (row + 1)) / h ))
    (( w < 1 )) && w=1

    # seitliches Wackeln (oben mehr, unten stabiler)
    local max_jitter=1  # $(( (h - row) / 3 ))
    (( max_jitter < 1 )) && max_jitter=1
    local jitter=$(( RANDOM % (2 * max_jitter + 1) - max_jitter ))

    local indent=$(( x - (w / 2) + jitter ))
    local pos_y=$(( y + row ))

    echo -ne "\e[${pos_y};${indent}H"

    for ((col=0; col<w; col++)); do
      local ch=${chars[$RANDOM % ${#chars[@]}]}
      
      # zufällige fg RGB
      local i=$(( RANDOM % ${#reds[@]} ))
      local r_fg=${reds[$i]} g_fg=${greens[$i]} b_fg=${blues[$i]}

      if (( col == 0 || col == w - 1 )); then
        # rand → kein hintergrund
        echo -ne "\e[38;2;${r_fg};${g_fg};${b_fg}m${ch}\e[0m"
      else
        # zufällige bg RGB
        local j=$(( RANDOM % ${#reds[@]} ))
        local r_bg=${reds[$j]} g_bg=${greens[$j]} b_bg=${blues[$j]}
        echo -ne "\e[38;2;${r_fg};${g_fg};${b_fg}m\e[48;2;${r_bg};${g_bg};${b_bg}m${ch}\e[0m"
      fi
    done
  done
}

# setup
clear
echo -ne "\e[?25l"  # cursor aus

# feuerschleife
while true; do
  echo -ne "\e[2J"     # gesamter bildschirm löschen
  echo -ne "\e[H"      # cursor nach oben links
  draw_fire_fg_rgb 40 10 19 10
  sleep 0.33
done


echo -ne "\e[?25h"  # cursor wieder an

