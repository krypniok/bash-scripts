#!/bin/bash

PASSWD="simon"

# auswahlmenü
choice=$(kdialog --menu "Powernap Dauer wählen:" \
    10   "10 Sekunden" \
    5    "5 Minuten" \
    10m  "10 Minuten" \
    15   "15 Minuten" \
    20   "20 Minuten" \
    25   "25 Minuten" \
    30   "30 Minuten" \
    60   "60 Minuten" \
    120  "2 Stunden" \
    240  "4 Stunden" \
    360  "6 Stunden" \
    480  "8 Stunden")

[ -z "$choice" ] && exit 0

# umrechnen in sekunden
case "$choice" in
  10)      seconds=10 ;;         # 10 Sekunden
  5)       seconds=$((5*60)) ;;  # 5 Minuten
  10m)     seconds=$((10*60)) ;; # 10 Minuten
  15)      seconds=$((15*60)) ;;
  20)      seconds=$((20*60)) ;;
  25)      seconds=$((25*60)) ;;
  30)      seconds=$((30*60)) ;;
  60)      seconds=$((60*60)) ;;   # 1 Stunde
  120)     seconds=$((120*60)) ;;  # 2 Stunden
  240)     seconds=$((240*60)) ;;  # 4 Stunden
  360)     seconds=$((360*60)) ;;  # 6 Stunden
  480)     seconds=$((480*60)) ;;  # 8 Stunden
esac

# rtcwake mit passwort
echo $PASSWD | sudo -S /usr/sbin/rtcwake -m mem -s "$seconds"

# aktuelle Lautstärke sichern
orig_vol=$(pactl get-sink-volume @DEFAULT_SINK@ | head -n1 | awk '{print $5}')

# Lautstärke auf 200% setzen
pactl set-sink-volume @DEFAULT_SINK@ 200%

# nach resume alarm starten
(
  while true; do
    paplay /usr/share/sounds/freedesktop/stereo/phone-incoming-call.oga
    sleep 2
  done
) &
alarm_pid=$!

# beenden-dialog
kdialog --msgbox "Aufgewacht! Wecker beenden mit OK."

# alarm stoppen
kill $alarm_pid

# Lautstärke zurücksetzen
pactl set-sink-volume @DEFAULT_SINK@ "$orig_vol"

