#!/bin/bash

# Lies den Code aus der Zwischenablage
temp_code=$(xclip -selection clipboard -o)

echo "$temp_code" > temp_code.c

# Erste Kompilation versuchen, Fehler abfangen
compile_output=$(gcc temp_code.c -o ausgabe 2>&1)

# Fehlermeldungen nach fehlenden Bibliotheken durchsuchen
missing_libs=()
while read -r line; do
    if [[ "$line" == *"undefined reference to"* ]]; then
        symbol=$(echo "$line" | awk -F'`' '{print $2}')
        
        case "$symbol" in
            gl* ) libname="GL" ;;  
            glfw* ) libname="glfw" ;;  
            * ) libname=$(echo "$symbol" | sed 's/_.*//') ;;  
        esac

        pkg_libs=$(pkg-config --libs "$libname" 2>/dev/null)
        if [[ -n "$pkg_libs" ]]; then
            missing_libs+=($pkg_libs)
        else
            missing_libs+=("-l$libname")
        fi
    fi
done <<< "$compile_output"

# Duplikate entfernen
missing_libs=($(echo "${missing_libs[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))

# Falls Bibliotheken fehlen, erneut kompilieren, Fehler unterdrücken
if [[ -n "${missing_libs[*]}" ]]; then
    echo "Fehlende Bibliotheken erkannt. Versuche Neu-Kompilation..."
    gcc temp_code.c -o ausgabe ${missing_libs[*]} 2>/dev/null
else
    gcc temp_code.c -o ausgabe 2>/dev/null
fi

# Falls erfolgreich, ausführen
test -f ausgabe && ./ausgabe

# Warten und aufräumen
read -n1 -r -p "Press any key to continue..."
rm -f ausgabe temp_code.c
