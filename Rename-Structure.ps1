param(
    [bool]$Fake = $false,
    [int]$SizeDivisor = 2
)

# Get current directory
$CurrentDir = Get-Location
Write-Host "Current Directory: $CurrentDir"

# Iterate through first-level subdirectories
Get-ChildItem -Directory | ForEach-Object {
    $FirstLevelDir = $_
    $FirstLevelName = $_.Name
    Write-Host "First-level Subdirectory: $FirstLevelName"

    if ($FirstLevelName -match '^\d+$') {
        $EpisodesProcessed = 1

        # Iterate through second-level subdirectories
        Get-ChildItem -Path $_.FullName -Directory | ForEach-Object {
            $SecondLevelDir = $_
            $SecondLevelName = $_.Name
            Write-Host "  Second-level Subdirectory: $SecondLevelName"

            if ($SecondLevelName -match '^\d+$') {
                # Find largest file and calculate filter size
                $LargestFile = Get-ChildItem -Path $_.FullName -File -Filter "*.mkv" | Sort-Object Length -Descending | Select-Object -First 1
                $FilterSize = [math]::Floor($LargestFile.Length / $SizeDivisor)

                # Move small files
                .\Move-SmallFiles.ps1 -SizeThreshold $FilterSize -Directory $SecondLevelDir.FullName

                # Rename and renumber files
                .\Rename-And-Renumber.ps1 -StartDir $SecondLevelDir.FullName -BaseName $CurrentDir -Season $FirstLevelName -Fake $Fake -Offset $EpisodesProcessed

                # Update processed episodes count
                $MkvCount = (Get-ChildItem -Path $SecondLevelDir.FullName -File -Filter "*.mkv").Count
                $EpisodesProcessed += $MkvCount
            }
        }
    }
}

