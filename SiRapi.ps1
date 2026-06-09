[CmdletBinding()]
param(
    [Alias('Folder')]
    [string] $Path,

    [switch] $Advanced,

    [switch] $Preview,

    [ValidateSet('Skip', 'Rename')]
    [string] $DuplicateAction = 'Skip',

    [switch] $Yes
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Write-Banner {
    Clear-Host
    Write-Host ''
    Write-Host '  +--------------------------------------------------+' -ForegroundColor Cyan
    Write-Host '  |          SiRapi - Asisten Perapih Folder        |' -ForegroundColor Cyan
    Write-Host '  |       Aman, cepat, dan tidak menimpa file       |' -ForegroundColor DarkCyan
    Write-Host '  +--------------------------------------------------+' -ForegroundColor Cyan
    Write-Host ''
}

function Write-Status {
    param(
        [Parameter(Mandatory)]
        [string] $Status,

        [Parameter(Mandatory)]
        [string] $Message,

        [Parameter(Mandatory)]
        [ConsoleColor] $Color
    )

    Write-Host ("  {0,-13} {1}" -f $Status, $Message) -ForegroundColor $Color
}

function Write-InfoLine {
    param(
        [Parameter(Mandatory)]
        [string] $Label,

        [Parameter(Mandatory)]
        [string] $Value
    )

    Write-Host ("  {0,-15}: " -f $Label) -NoNewline -ForegroundColor DarkGray
    Write-Host $Value -ForegroundColor White
}

function Format-FileSize {
    param([long] $Bytes)

    if ($Bytes -ge 1GB) {
        return '{0:N2} GB' -f ($Bytes / 1GB)
    }

    if ($Bytes -ge 1MB) {
        return '{0:N2} MB' -f ($Bytes / 1MB)
    }

    if ($Bytes -ge 1KB) {
        return '{0:N2} KB' -f ($Bytes / 1KB)
    }

    return "$Bytes B"
}

function Test-ProtectedPath {
    param(
        [Parameter(Mandatory)]
        [string] $TargetPath
    )

    $normalizedTarget = [System.IO.Path]::GetFullPath($TargetPath).TrimEnd('\')
    $driveRoot = [System.IO.Path]::GetPathRoot($normalizedTarget).TrimEnd('\')

    if ($normalizedTarget -eq $driveRoot) {
        return $true
    }

    $protectedPaths = @(
        [Environment]::GetFolderPath('Windows')
        [Environment]::GetFolderPath('System')
        [Environment]::GetFolderPath('ProgramFiles')
        [Environment]::GetFolderPath('ProgramFilesX86')
        [Environment]::GetFolderPath('CommonApplicationData')
        [Environment]::GetFolderPath('ApplicationData')
        [Environment]::GetFolderPath('LocalApplicationData')
    ) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }

    foreach ($protectedPath in $protectedPaths) {
        $normalizedProtectedPath = [System.IO.Path]::GetFullPath($protectedPath).TrimEnd('\')

        if (
            $normalizedTarget -eq $normalizedProtectedPath -or
            $normalizedTarget.StartsWith("$normalizedProtectedPath\", [System.StringComparison]::OrdinalIgnoreCase)
        ) {
            return $true
        }
    }

    return $false
}

function Get-SimpleCategory {
    param([string] $Extension)

    $simpleCategories = [ordered]@{
        Images       = @('.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp', '.heic', '.svg')
        Videos       = @('.mp4', '.avi', '.mkv', '.mov', '.wmv', '.webm', '.m4v')
        Documents    = @('.pdf', '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx', '.txt', '.csv')
        Applications = @('.exe', '.msi', '.msix', '.appx')
        Archives     = @('.zip', '.rar', '.7z', '.tar', '.gz')
        Audio        = @('.mp3', '.wav', '.aac', '.flac', '.m4a', '.ogg')
    }

    foreach ($category in $simpleCategories.Keys) {
        if ($simpleCategories[$category] -contains $Extension) {
            return $category
        }
    }

    return 'Others'
}

function Get-AdvancedCategory {
    param([string] $Extension)

    $advancedCategories = [ordered]@{
        'Images\Photos'                  = @('.jpg', '.jpeg', '.heic', '.raw', '.cr2', '.nef')
        'Images\Graphics'                = @('.png', '.gif', '.bmp', '.webp', '.svg', '.ico')
        'Videos'                         = @('.mp4', '.avi', '.mkv', '.mov', '.wmv', '.webm', '.m4v')
        'Documents\PDF'                  = @('.pdf')
        'Documents\Word'                 = @('.doc', '.docx', '.odt', '.rtf')
        'Documents\Spreadsheets'         = @('.xls', '.xlsx', '.ods')
        'Documents\Presentations'        = @('.ppt', '.pptx', '.odp')
        'Documents\Text'                 = @('.txt', '.md')
        'Applications\Installers'        = @('.exe', '.msi', '.msix', '.appx')
        'Archives'                       = @('.zip', '.rar', '.7z', '.tar', '.gz', '.bz2')
        'Audio'                          = @('.mp3', '.wav', '.aac', '.flac', '.m4a', '.ogg')
        'Code'                           = @('.ps1', '.py', '.js', '.ts', '.html', '.css', '.java', '.cs', '.cpp', '.c', '.php', '.sql', '.json', '.xml', '.yaml', '.yml')
        'Data'                           = @('.csv', '.db', '.sqlite', '.log')
        'Books'                          = @('.epub', '.mobi', '.azw', '.azw3')
        'Fonts'                          = @('.ttf', '.otf', '.woff', '.woff2')
        'Others'                         = @()
    }

    foreach ($category in $advancedCategories.Keys) {
        if ($advancedCategories[$category] -contains $Extension) {
            return $category
        }
    }

    return 'Others'
}

function Get-AvailableDestination {
    param(
        [Parameter(Mandatory)]
        [string] $DestinationPath
    )

    if (-not (Test-Path -LiteralPath $DestinationPath)) {
        return $DestinationPath
    }

    $directory = Split-Path -Path $DestinationPath -Parent
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($DestinationPath)
    $extension = [System.IO.Path]::GetExtension($DestinationPath)
    $number = 2

    do {
        $candidate = Join-Path -Path $directory -ChildPath ("{0} ({1}){2}" -f $baseName, $number, $extension)
        $number++
    } while (Test-Path -LiteralPath $candidate)

    return $candidate
}

Write-Banner

$interactiveMode = [string]::IsNullOrWhiteSpace($Path)

if ($interactiveMode) {
    $currentDirectory = (Get-Location).ProviderPath
    $downloadsDirectory = Join-Path -Path $HOME -ChildPath 'Downloads'

    Write-Host '  PILIH FOLDER' -ForegroundColor Cyan
    Write-Host '  [1] Downloads' -ForegroundColor White
    Write-Host '  [2] Folder PowerShell saat ini' -ForegroundColor White
    Write-Host '  [3] Masukkan lokasi folder lain' -ForegroundColor White
    Write-Host ''

    $folderChoice = Read-Host '  Pilihan (Enter = Downloads)'

    switch ($folderChoice) {
        '2' { $Path = $currentDirectory }
        '3' { $Path = Read-Host '  Masukkan lokasi folder' }
        default { $Path = $downloadsDirectory }
    }
}

if ([string]::IsNullOrWhiteSpace($Path)) {
    Write-Status -Status '[GAGAL]' -Message 'Lokasi folder tidak boleh kosong.' -Color Red
    return
}

$Path = $Path.Trim().Trim('"').Trim("'")

try {
    $resolvedPath = Resolve-Path -LiteralPath $Path -ErrorAction Stop

    if ($resolvedPath.Provider.Name -ne 'FileSystem' -or -not (Test-Path -LiteralPath $resolvedPath.ProviderPath -PathType Container)) {
        throw "Lokasi bukan folder sistem file: $Path"
    }

    $workingDirectory = $resolvedPath.ProviderPath
}
catch {
    Write-Status -Status '[GAGAL]' -Message "Folder tidak ditemukan atau tidak dapat diakses: $Path" -Color Red
    return
}

if (Test-ProtectedPath -TargetPath $workingDirectory) {
    Write-Status -Status '[DIBATALKAN]' -Message 'Folder sistem atau folder aplikasi dilindungi.' -Color Red
    Write-InfoLine -Label 'Lokasi' -Value $workingDirectory
    return
}

if ($interactiveMode) {
    Write-Host ''
    Write-Host '  PILIH MODE' -ForegroundColor Cyan
    Write-Host '  [1] Pintar  - kategori lebih detail' -ForegroundColor White
    Write-Host '  [2] Standar - kategori sederhana' -ForegroundColor White
    Write-Host '  [3] Preview - lihat rencana tanpa memindahkan' -ForegroundColor White
    Write-Host ''

    $modeChoice = Read-Host '  Pilihan (Enter = Pintar)'

    switch ($modeChoice) {
        '2' { $Advanced = $false }
        '3' {
            $Advanced = $true
            $Preview = $true
        }
        default { $Advanced = $true }
    }
}

$scriptPath = if ($PSCommandPath) {
    [System.IO.Path]::GetFullPath($PSCommandPath)
}
else {
    $null
}

$files = @(
    Get-ChildItem -LiteralPath $workingDirectory -File |
        Where-Object {
            $_.Name -ne 'SiRapi.ps1' -and
            (-not $scriptPath -or [System.IO.Path]::GetFullPath($_.FullName) -ne $scriptPath)
        }
)

$totalSize = ($files | Measure-Object -Property Length -Sum).Sum
if ($null -eq $totalSize) {
    $totalSize = 0
}

$modeName = if ($Advanced) { 'Pintar' } else { 'Standar' }
if ($Preview) {
    $modeName += ' + Preview'
}

Write-Host ''
Write-Host '  RINGKASAN RENCANA' -ForegroundColor Cyan
Write-InfoLine -Label 'Folder' -Value $workingDirectory
Write-InfoLine -Label 'Mode' -Value $modeName
Write-InfoLine -Label 'Jumlah file' -Value ([string] $files.Count)
Write-InfoLine -Label 'Total ukuran' -Value (Format-FileSize -Bytes $totalSize)
Write-InfoLine -Label 'Duplikat' -Value $DuplicateAction
Write-Host ''

if ($files.Count -eq 0) {
    Write-Status -Status '[BERSIH]' -Message 'Tidak ada file yang perlu dirapikan.' -Color Green
    return
}

if (-not $Preview -and -not $Yes) {
    $confirmation = Read-Host '  Ketik Y untuk mulai, selain itu membatalkan'

    if ($confirmation -notmatch '^(?i:y|ya)$') {
        Write-Status -Status '[DIBATALKAN]' -Message 'Tidak ada file yang dipindahkan.' -Color Yellow
        return
    }

    Write-Host ''
}

$movedCount = 0
$skippedCount = 0
$renamedCount = 0
$errorCount = 0
$categorySummary = @{}

foreach ($file in $files) {
    $extension = $file.Extension.ToLowerInvariant()
    $category = if ($Advanced) {
        Get-AdvancedCategory -Extension $extension
    }
    else {
        Get-SimpleCategory -Extension $extension
    }

    if (-not $categorySummary.ContainsKey($category)) {
        $categorySummary[$category] = 0
    }
    $categorySummary[$category]++

    $destinationDirectory = Join-Path -Path $workingDirectory -ChildPath $category
    $destinationPath = Join-Path -Path $destinationDirectory -ChildPath $file.Name
    $wasRenamed = $false

    if (Test-Path -LiteralPath $destinationPath) {
        if ($DuplicateAction -eq 'Rename') {
            $destinationPath = Get-AvailableDestination -DestinationPath $destinationPath
            $wasRenamed = $true
        }
        else {
            Write-Status -Status '[DILEWATI]' -Message "$($file.Name) -> $category (nama sudah ada)" -Color Yellow
            $skippedCount++
            continue
        }
    }

    if ($Preview) {
        $previewName = [System.IO.Path]::GetFileName($destinationPath)
        $previewMessage = if ($wasRenamed) {
            "$($file.Name) -> $category\$previewName (nama baru)"
        }
        else {
            "$($file.Name) -> $category"
        }

        Write-Status -Status '[RENCANA]' -Message $previewMessage -Color DarkCyan
        continue
    }

    try {
        if (-not (Test-Path -LiteralPath $destinationDirectory -PathType Container)) {
            $null = New-Item -Path $destinationDirectory -ItemType Directory
        }

        Move-Item -LiteralPath $file.FullName -Destination $destinationPath -ErrorAction Stop

        if ($wasRenamed) {
            Write-Status -Status '[GANTI NAMA]' -Message "$($file.Name) -> $category\$([System.IO.Path]::GetFileName($destinationPath))" -Color Magenta
            $renamedCount++
        }
        else {
            $color = if ($category -eq 'Others') { [ConsoleColor]::Gray } else { [ConsoleColor]::Green }
            Write-Status -Status '[RAPI!]' -Message "$($file.Name) -> $category" -Color $color
        }

        $movedCount++
    }
    catch {
        Write-Status -Status '[GAGAL]' -Message "$($file.Name) - $($_.Exception.Message)" -Color Red
        $errorCount++
    }
}

Write-Host ''
Write-Host '  HASIL PER KATEGORI' -ForegroundColor Cyan
foreach ($category in ($categorySummary.Keys | Sort-Object)) {
    Write-Host ("  {0,-34} {1,4} file" -f $category, $categorySummary[$category]) -ForegroundColor DarkGray
}

Write-Host ''
if ($Preview) {
    Write-Status -Status '[PREVIEW]' -Message "$($files.Count) file ditampilkan. Tidak ada file yang dipindahkan." -Color Cyan
}
else {
    Write-Status -Status '[SELESAI]' -Message "$movedCount dipindahkan, $renamedCount diganti nama, $skippedCount dilewati, $errorCount gagal." -Color Cyan
}
