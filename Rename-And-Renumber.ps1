param(
    [string]$StartDir = ".",
    [string]$BaseName,
    [int]$Season,
    [int]$Offset = 1,
    [bool]$Fake = $false
)

# Ensure output directory if testing
if ($Fake) {
    $TestDir = Join-Path -Path $StartDir -ChildPath "test"
    if (!(Test-Path -Path $TestDir)) {
        New-Item -ItemType Directory -Path $TestDir | Out-Null
    }
}

# Process files
Get-ChildItem -Path $StartDir -File -Filter "title_t*.mkv" | ForEach-Object {
    $NN = ($_ -replace '.*title_t(\d{2}).*', '$1') -as [int]
    $MM = $NN + $Offset
    $NewName = "$BaseName - S$Season" + "E" + $MM.ToString("00") + ".mkv"

    if ($Fake) {
        New-Item -ItemType File -Path (Join-Path $TestDir $NewName) | Out-Null
    } else {
        Rename-Item -Path $_.FullName -NewName $NewName
    }
}

