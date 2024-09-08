#!/bin/bash

# Vérification de la présence d'une batterie
if [ -d "/sys/class/power_supply/BAT0" ]; then
  # Afficher les informations sur la batterie
  battery_percentage=$(cat /sys/class/power_supply/BAT0/capacity)
  echo "Battery: $battery_percentage%"
else
  # Pas de batterie présente, ne rien afficher
  echo ""
fi

