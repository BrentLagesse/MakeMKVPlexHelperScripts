param(
    [int]$SizeThreshold = 1000000000,  # Default size threshold in bytes
    [string]$Directory = "."
)

# Define the temporary directory
$TempDir = Join-Path -Path $Directory -ChildPath "temp"

# Create the temporary directory if it doesn't exist
if (!(Test-Path -Path $TempDir)) {
    New-Item -ItemType Directory -Path $TempDir | Out-Null
}

# Find and move files under the size threshold
Get-ChildItem -Path $Directory -File -Filter "*.mkv" | Where-Object { $_.Length -lt $SizeThreshold } | ForEach-Object {
    Move-Item -Path $_.FullName -Destination $TempDir
}

Write-Host "Files under $SizeThreshold bytes have been moved to $TempDir."

