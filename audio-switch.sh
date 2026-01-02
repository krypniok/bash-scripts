#!/bin/bash

# Überprüfen, ob ein Parameter angegeben wurde
if [ -z "$1" ]; then
  echo "Bitte entweder 'INTERN' (INTERNn) oder 'EXTERN' (HDMI) angeben."
  exit 1
fi

# Karte und Ausgabe
CARD="alsa_card.pci-0000_00_1b.0"
INTERN_OUTPUT="alsa_output.pci-0000_00_1b.0.analog-stereo"
EXTERN_OUTPUT="alsa_output.pci-0000_00_1b.0.hdmi-stereo"

# Auswahl basierend auf dem Parameter
if [ "$1" == "INTERN" ]; then
  # Auf die INTERNne Soundkarte umschalten
  pactl set-card-profile $CARD output:analog-stereo
  pactl set-default-sink $INTERN_OUTPUT
  echo "Audioausgabe auf INTERNne Soundkarte (Standard) umgeschaltet."
elif [ "$1" == "EXTERN" ]; then
  # Auf HDMI umschalten
  pactl set-card-profile $CARD output:hdmi-stereo
  pactl set-default-sink $EXTERN_OUTPUT
  echo "Audioausgabe auf HDMI umgeschaltet."
else
  echo "Ungültiger Parameter! Verwenden Sie 'INTERN' oder 'EXTERN'."
  exit 1
fi

