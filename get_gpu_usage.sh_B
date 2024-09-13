#!/bin/bash

# Détection du GPU et affichage de l'utilisation
if lspci | grep -i 'nvidia' > /dev/null 2>&1; then
  # Si c'est un GPU NVIDIA
  nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits
elif lspci | grep -i 'amd' > /dev/null 2>&1; then
  # Si c'est un GPU AMD
  rocm-smi --showuse | grep '%' | awk '{print $5}'
elif lspci | grep -i 'intel' > /dev/null 2>&1; then
  # Si c'est un GPU Intel
  intel_gpu_top -l 1 | grep 'Render/3D' | awk '{print $2}'
else
  echo "No GPU"
fi

