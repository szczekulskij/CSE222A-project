#!/bin/bash

# Configuration
start_time=$(date +%s.%N)  # Get the start time
duration=120                # Duration in seconds
output_file1="Cubic_0_BulkTraffic_u1.txt"  # Output file for port 1
output_file2="Cubic_0_BulkTraffic_u2.txt"  # Output file for port 2
peer1="172.31.28.16:5200"  # Peer address and port for first connection
peer2="172.31.28.16:5203"  # Peer address and port for second connection

# Function to create or clear a file
initialize_file() {
    local file=$1
    if [ -f "$file" ]; then
        rm "$file"  # Delete the file if it exists
        echo "Existing file $file deleted."
    else
        touch "$file"  # Create the file if it doesn't exist
        echo "New file $file created."
    fi
}

# Initialize output files
initialize_file "$output_file1"
initialize_file "$output_file2"

# Loop to collect data for the specified duration
while true; do
    current_time=$(date +%s.%N)
    elapsed_time=$(echo "$current_time - $start_time" | bc)

    if (( $(echo "$elapsed_time >= $duration" | bc -l) )); then
        break
    fi

    # Capture filtered ss data for peer1
    timestamp=$(date +"%Y-%m-%d %H:%M:%S.%3N")
    echo "Timestamp: $timestamp" >> "$output_file1"
    sudo ss -tni | grep "$peer1" >> "$output_file1"
    echo "-------------------------------------" >> "$output_file1"

    # Capture filtered ss data for peer2
    echo "Timestamp: $timestamp" >> "$output_file2"
    sudo ss -tni | grep "$peer2" >> "$output_file2"
    echo "-------------------------------------" >> "$output_file2"
done

echo "Data collection completed for $duration seconds."
