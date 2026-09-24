param(
    [string]$ProjectRoot = (Split-Path -Parent $PSScriptRoot),
    [int]$OutputSize = 80
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$spriteRoot = Join-Path $ProjectRoot 'sprites\Pokemon'
$spriteResource = Join-Path $spriteRoot 'Pokemon.yy'
$sourceRoot = Join-Path $ProjectRoot 'art\source\sprites\pokemon_shuffle'
$spriteData = Get-Content -Raw -LiteralPath $spriteResource | ConvertFrom-Json
$frameIds = @($spriteData.frames | ForEach-Object { $_.name })
$layerId = $spriteData.layers[0].name

if ($frameIds.Count -ne 151) {
    throw "Pokemon sprite must contain 151 frames; found $($frameIds.Count)."
}

New-Item -ItemType Directory -Force -Path $sourceRoot | Out-Null

$downloadRecords = @()
for ($batchStart = 1; $batchStart -le 151; $batchStart += 50) {
    $batchEnd = [Math]::Min($batchStart + 49, 151)
    $titles = for ($number = $batchStart; $number -le $batchEnd; $number++) {
        'File:Shuffle{0:D3}.png' -f $number
    }
    $encodedTitles = [Uri]::EscapeDataString(($titles -join '|'))
    $apiUrl = "https://archives.bulbagarden.net/w/api.php?action=query&format=json&redirects=1&prop=imageinfo&iiprop=url&titles=$encodedTitles"
    $response = Invoke-RestMethod -Uri $apiUrl -Headers @{
        'User-Agent' = 'PokagiRemaster/1.0 (sprite migration)'
    }

    foreach ($pageProperty in $response.query.pages.PSObject.Properties) {
        $page = $pageProperty.Value
        if (-not $page.imageinfo -or -not $page.imageinfo[0].url) {
            throw "No downloadable image found for $($page.title)."
        }
        $fileName = $page.title.Substring('File:'.Length)
        $downloadRecords += [pscustomobject]@{
            FileName = $fileName
            Url = $page.imageinfo[0].url
            Destination = Join-Path $sourceRoot $fileName
        }
    }
}

if ($downloadRecords.Count -ne 151) {
    throw "Expected 151 downloadable icons; found $($downloadRecords.Count)."
}

$downloadRecords | ForEach-Object -Parallel {
    Invoke-WebRequest -Uri $_.Url -OutFile $_.Destination -Headers @{
        'User-Agent' = 'PokagiRemaster/1.0 (sprite migration)'
    }
} -ThrottleLimit 6

Add-Type -AssemblyName System.Drawing

for ($index = 0; $index -lt 151; $index++) {
    $number = $index + 1
    $sourcePath = Join-Path $sourceRoot ('Shuffle{0:D3}.png' -f $number)
    $frameId = $frameIds[$index]
    $framePath = Join-Path $spriteRoot "$frameId.png"
    $layerDirectory = Join-Path $spriteRoot "layers\$frameId"
    $layerPath = Join-Path $layerDirectory "$layerId.png"
    $temporaryPath = Join-Path $env:TEMP ("pokagi-shuffle-$frameId.png")

    if (-not (Test-Path -LiteralPath $sourcePath)) {
        throw "Missing downloaded icon: $sourcePath"
    }
    New-Item -ItemType Directory -Force -Path $layerDirectory | Out-Null

    $sourceImage = [System.Drawing.Image]::FromFile($sourcePath)
    try {
        if ($sourceImage.Width -ne 256 -or $sourceImage.Height -ne 256) {
            throw "Unexpected dimensions for ${sourcePath}: $($sourceImage.Width)x$($sourceImage.Height)"
        }

        $bitmap = New-Object System.Drawing.Bitmap $OutputSize, $OutputSize, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
        try {
            $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
            try {
                $graphics.Clear([System.Drawing.Color]::Transparent)
                $graphics.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
                $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
                $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
                $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
                $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
                $graphics.DrawImage($sourceImage, 0, 0, $OutputSize, $OutputSize)
            } finally {
                $graphics.Dispose()
            }
            $bitmap.Save($temporaryPath, [System.Drawing.Imaging.ImageFormat]::Png)
        } finally {
            $bitmap.Dispose()
        }
    } finally {
        $sourceImage.Dispose()
    }

    Copy-Item -Force -LiteralPath $temporaryPath -Destination $framePath
    Copy-Item -Force -LiteralPath $temporaryPath -Destination $layerPath
    Remove-Item -Force -LiteralPath $temporaryPath
}

Write-Output "Imported 151 Shuffle icons at ${OutputSize}x${OutputSize}."
