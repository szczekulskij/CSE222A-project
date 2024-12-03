#!/bin/bash

# Configuration
start_time=$(date +%s.%N)  # Get the start time
duration=60                 # Duration in seconds
output_file="BBR_0_BulkTraffic.txt"  # Output file
# port="8808"                # Destination port to filter
port="5201"                # Destination port to filter

# Create or clear the output file
if [ -f "$output_file" ]; then
    rm "$output_file"  # Delete the file if it exists
    echo "Existing file $output_file deleted."
else
    touch "$output_file"  # Create the file if it doesn't exist
    echo "New file $output_file created."
fi

# Loop to collect data for the specified duration
while true; do
    current_time=$(date +%s.%N) 
    elapsed_time=$(echo "$current_time - $start_time" | bc)

    if (( $(echo "$elapsed_time >= $duration" | bc -l) )); then
        break
    fi

    # Capture filtered ss data
    timestamp=$(date +"%Y-%m-%d %H:%M:%S.%3N")
    echo "Timestamp: $timestamp" >> "$output_file"
    sudo ss -tni dst :$port >> "$output_file"
    echo "-------------------------------------" >> "$output_file"
done

echo "Data collection completed for $duration seconds."
