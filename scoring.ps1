# The code in the script is subject to the OPSWAT Inc. Terms of Service set forth at https://www.opswat.com/legal.
# (c) 2024 OPSWAT Inc.
# WARNING: This file is just an example, use and modify it at your own risk.


# ----- CONFIGURATION -----

# Set your desired threshold
$threshold = 5

# Define the AV engines and their weights
$engineWeights = @{
    "AhnLab" = 1
    "Avira" = 1
    "Bitdefender" = 3
    "ClamAV" = 2
    "ESET" = 2
    "K7" = 2
    "Quick Heal" = 2
    "Vir.IT eXplorer" = 1
}

# ----- /CONFIGURATION -----



# Read JSON data from stdin
$fileContent = [System.Console]::In.ReadToEnd()

# Convert JSON data to PowerShell object
$jsonData = $fileContent | ConvertFrom-Json

# Initialize sum
$sum = 0

# Loop through each AV engine
foreach ($engine in $engineWeights.Keys) {
	if (![bool]($jsonData.scan_results.scan_details.PSobject.Properties.name -match $engine)) {
		Write-Host "$($engine) cannot be found"
		exit 1
	}

    # Use PowerShell object property to access the scan_result_i value
    $scanResult = $jsonData.scan_results.scan_details.$engine.scan_result_i
    Write-Host "$($engine): $($scanResult)"

    if ($scanResult -eq 1) {
        $sum += $engineWeights[$engine]
    }
}

Write-Host "Total Weight Sum: $sum"

# Check if the sum exceeds the threshold
if ($sum -ge $threshold) {
    Write-Host "Sum of weights exceeds the threshold. Exiting with status 1."
    exit 1
}
else {
    Write-Host "Sum of weights is within the threshold. Exiting with status 0."
    exit 0
}
