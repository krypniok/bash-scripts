#!/bin/bash

# Befehl zum Anzeigen der als "rc" markierten Kernelversionen
rc_kernels=$(dpkg --list | awk '/^rc.*linux-image-5\.4/ { print $2 }')

# Überprüfen, ob als "rc" markierte Kernelversionen vorhanden sind
if [ -n "$rc_kernels" ]; then
    echo "Entferne als 'rc' markierte Kernelversionen: $rc_kernels"
    
    # Befehl zum Entfernen der als "rc" markierten Kernelversionen
    sudo apt purge $rc_kernels
    
    # Aktualisiere Grub
    sudo update-grub
    
    echo "Als 'rc' markierte Kernelversionen wurden entfernt."
else
    echo "Keine als 'rc' markierten Kernelversionen gefunden."
fi

# Befehle zum Aufräumen der root-Partition
echo "Führe Aufräum-Befehle für die root-Partition aus..."
sudo apt autoremove --purge
sudo apt clean
sudo apt autoclean

# Befehle zum Aufräumen von /tmp und /var/log
echo "Führe Aufräum-Befehle für /tmp und /var/log aus..."
sudo rm -rf /tmp/*
sudo rm -r /var/log/*

# Befehl zum Aufräumen des Papierkorbs
echo "Leere den Papierkorb..."
rm -rf ~/.local/share/Trash/*

echo "Aufräum-Befehle wurden ausgeführt."
