
nd display usage and memory percentage
if lspci | grep -i 'nvidia' > /dev/null 2>&1; then
      # For NVIDIA GPU
        utilization=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
          memory_used=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits)
            memory_total=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits)
              memory_percentage=$(awk "BEGIN {printf \"%d\", ($memory_used/$memory_total) * 100}")
                echo "$utilization% | Memory: $memory_percentage%"
            elif lspci | grep -i 'amd' > /dev/null 2>&1; then
                  # For AMD GPU
                    utilization=$(rocm-smi --showuse | grep '%' | awk '{print $5}')
                      memory_used=$(rocm-smi --showmemuse | grep '%' | awk '{print $5}' | sed 's/%//')
                        memory_percentage=$(printf "%d" "$memory_used")
                          echo "$utilization% | Memory: $memory_percentage%"
                      elif lspci | grep -i 'intel' > /dev/null 2>&1; then
                            # For Intel GPU
                              utilization=$(intel_gpu_top -l 1 | grep 'Render/3D' | awk '{print $2}')
                                # Intel GPUs don't typically report memory usage like NVIDIA/AMD, so you can skip memory for now
                                  echo "$utilization% | Memory: N/A"
                              else
                                    echo "No GPU"
fi

