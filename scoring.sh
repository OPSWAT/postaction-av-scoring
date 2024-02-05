#!/bin/bash

# The code in the script is subject to the OPSWAT Inc. Terms of Service set forth at https://www.opswat.com/legal.
# (c) 2024 OPSWAT Inc.
# WARNING: This file is just an example, use and modify it at your own risk.


# ----- CONFIGURATION -----

threshold=5  # Set your desired threshold

# Define the AV engines and their weights
declare -A engine_weights
engine_weights["AhnLab"]=1
engine_weights["Bitdefender"]=2
engine_weights["ClamAV"]=1
engine_weights["ESET"]=2
engine_weights["K7"]=1

# ----- /CONFIGURATION -----



# Read JSON data from stdin
json_data=$(cat)

# Initialize sum
sum=0

# Loop through each AV engine
for engine in "${!engine_weights[@]}"; do
  pattern="\"$engine\":\{[^\}]*\"scan_result_i\":([0-9]+)"
  if [[ "$json_data" =~ $pattern ]]; then
    scan_result_i="${BASH_REMATCH[1]}"
    echo "$engine: $scan_result_i"
    if [ "$scan_result_i" -eq 1 ]; then
      ((sum+=${engine_weights[$engine]}))
    fi
  else
    echo "$engine: Not found"
	exit 1
  fi
done

echo "Total Weight Sum: $sum"

# Check if the sum exceeds the threshold
if [ "$sum" -ge "$threshold" ]; then
  echo "Sum of weights exceeds the threshold. Exiting with status 1."
  exit 1
else
  echo "Sum of weights is within the threshold. Exiting with status 0."
  exit 0
fi
