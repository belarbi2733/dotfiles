#!/bin/bash

# CPU Usage
cpu_usage=$(vmstat 1 2 | tail -1 | awk '{print 100-$15}')
if [ "$cpu_usage" -lt 50 ]; then
  cpu_color="#[fg=$(tmux show-option -gqv @sysstat_cpu_color_low)]"
elif [ "$cpu_usage" -lt 80 ]; then
  cpu_color="#[fg=$(tmux show-option -gqv @sysstat_cpu_color_medium)]"
else
  cpu_color="#[fg=$(tmux show-option -gqv @sysstat_cpu_color_stress)]"
fi

# RAM Usage
ram_usage=$(free | grep Mem | awk '{print int($3/$2 * 100.0)}')
if [ "$ram_usage" -lt 50 ]; then
  ram_color="#[fg=$(tmux show-option -gqv @sysstat_ram_color_low)]"
elif [ "$ram_usage" -lt 80 ]; then
  ram_color="#[fg=$(tmux show-option -gqv @sysstat_ram_color_medium)]"
else
  ram_color="#[fg=$(tmux show-option -gqv @sysstat_ram_color_stress)]"
fi

# GPU Usage (à adapter selon votre script GPU)
gpu_usage=$(./.get_gpu_usage.sh)  # remplacez ceci par votre méthode réelle d'obtention de l'utilisation GPU
if [ "$gpu_usage" -lt 50 ]; then
  gpu_color="#[fg=$(tmux show-option -gqv @sysstat_gpu_color_low)]"
elif [ "$gpu_usage" -lt 80 ]; then
  gpu_color="#[fg=$(tmux show-option -gqv @sysstat_gpu_color_medium)]"
else
  gpu_color="#[fg=$(tmux show-option -gqv @sysstat_gpu_color_stress)]"
fi

# Affichage final des couleurs pour TMUX
echo "$cpu_color CPU: ${cpu_usage}% #[default] | $ram_color RAM: ${ram_usage}% #[default] | $gpu_color GPU: ${gpu_usage}% #[default]"

