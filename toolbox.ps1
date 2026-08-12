[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# ==============================================================================
#                     TOOLBOX BY LERDRAGON - TERMINAL INTERACTIF
#                          Version v0.6 [Site & Correctif UTF-8]
# ==============================================================================

$Host.UI.RawUI.WindowTitle = "DRAGONRIA TOOLBOX v0.6 - BY LERDRAGON"
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

function Show-Header {
    Clear-Host
    Write-Host "==================================================================" -ForegroundColor DarkCyan
    Write-Host "                TOOLBOX BY LERDRAGON - SYSTEM & NETWORK           " -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "                     Version v0.6 [11/08/2026]                    " -ForegroundColor Cyan
    Write-Host "==================================================================" -ForegroundColor DarkCyan
    
    if (-not $isAdmin) {
        Write-Host "  Mode Utilisateur Standard (Certaines fonctions necessitent l'Admin)" -ForegroundColor DarkYellow
    } else {
        Write-Host "  Mode Administrateur Actif" -ForegroundColor Green
    }
    
    Write-Host "  HISTORIQUE DES MISES A JOUR :" -ForegroundColor DarkGray
    Write-Host "  - v0.1 [01/08/2026] : Module Config System + Export .txt" -ForegroundColor DarkGray
    Write-Host "  - v0.2 [03/08/2026] : Module Reseau & RDP interactif + Menu TUI" -ForegroundColor DarkGray
    Write-Host "  - v0.3 [06/08/2026] : Integration Benchmark Dragon Score" -ForegroundColor DarkGray
    Write-Host "  - v0.4 [08/08/2026] : Moniteur Temps Reel optimise (sans lag HDD)" -ForegroundColor DarkGray
    Write-Host "  - v0.5 [10/08/2026] : Lancement/Fermeture & Integration Reseaux LeRDragon" -ForegroundColor DarkGray
    Write-Host "  - v0.6 [11/08/2026] : Lancement Officiel du Site Web & Correction Encodage" -ForegroundColor Green
    Write-Host "------------------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "  PROCHAINES MAJ PREVUES (Retour en France 19-21 Aout) :" -ForegroundColor Magenta
    Write-Host "  - Multi-GPU/Disque/Ping dans le Bench + Note de Perf" -ForegroundColor DarkGray
    Write-Host "  - Temperatues CPU/GPU + Frequence de rafraichissement dans l'Onglet 4" -ForegroundColor DarkGray
    Write-Host "  - Onglet 5 : Mes Reseaux Sociaux & Support Multilingue (FR/EN)" -ForegroundColor DarkGray
    Write-Host "==================================================================" -ForegroundColor DarkCyan
    Write-Host ""
}

# ------------------------------------------------------------------------------
# MODULE 1 : DETAIL CONFIG BY LERDRAGON
# ------------------------------------------------------------------------------
function Invoke-ConfigModule {
    Show-Header
    Write-Host "--- [1] DETAIL CONFIG BY LERDRAGON ---`n" -ForegroundColor Cyan

    $pcName = $env:COMPUTERNAME
    $CPU = Get-CimInstance Win32_Processor | Select-Object -First 1
    $Sys = Get-CimInstance Win32_ComputerSystem
    $MB = Get-CimInstance Win32_BaseBoard
    $BIOS = Get-CimInstance Win32_BIOS
    $OS = Get-CimInstance Win32_OperatingSystem

    $RAMModules = Get-CimInstance Win32_PhysicalMemory
    $RAMConsole = ""
    $slotCount = 1

    foreach ($ram in $RAMModules) {
        $sizeGB = [math]::Round($ram.Capacity / 1GB, 2)
        $manuf = if ($ram.Manufacturer -and $ram.Manufacturer -notmatch "0000|0012") { $ram.Manufacturer.Trim() } else { "Generique / OEM" }
        $speed = if ($ram.Speed) { "$($ram.Speed) MHz" } else { "1600 MHz" }
        $RAMConsole += "  - Slot $slotCount : $sizeGB Go | $speed | Marque : $manuf`n"
        $slotCount++
    }

    $GPUs = Get-CimInstance Win32_VideoController
    $GPUConsole = ""
    foreach ($g in $GPUs) {
        $vramGB = if ($g.AdapterRAM) { [math]::Round([math]::Abs($g.AdapterRAM) / 1GB, 2) } else { 0 }
        $GPUConsole += "  - $($g.Name) ($vramGB Go VRAM) | Pilote : $($g.DriverVersion)`n"
    }

    $DiskConsole = ""
    $LogicalDisks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"
    foreach ($disk in $LogicalDisks) {
        $totalGB = [math]::Round($disk.Size / 1GB, 2)
        $freeGB = [math]::Round($disk.FreeSpace / 1GB, 2)
        $percentFree = [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 1)
        $DiskConsole += "  - Disque ($($disk.DeviceID)) : $freeGB Go libres / $totalGB Go ($percentFree % libre)`n"
    }

    $CPUFreqBase = if ($CPU.MaxClockSpeed) { "$([math]::Round($CPU.MaxClockSpeed / 1000, 2)) GHz" } else { "N/A" }
    
    $consoleReport = @"
RAPPORT CONFIGURATION SYSTEME - $pcName
================================================================================
[ PROCESSEUR ] : $($CPU.Name) ($($CPU.NumberOfCores) Coeurs / $CPUFreqBase)
[ CARTE MERE ] : $($MB.Manufacturer) $($MB.Product) (BIOS: $($BIOS.SMBIOSBIOSVersion))
[ MEMOIRE RAM] : $([math]::Round($Sys.TotalPhysicalMemory / 1GB, 2)) Go
$RAMConsole
[ GRAPHIQUE  ] :
$GPUConsole
[ STOCKAGE   ] :
$DiskConsole
[ SYSTEME OS ] : $($OS.Caption) ($($OS.OSArchitecture))
================================================================================
"@

    Write-Host $consoleReport -ForegroundColor White
    Write-Host "------------------------------------------------------------------" -ForegroundColor DarkGray
    $choice = Read-Host "Voulez-vous enregistrer le rapport complet (.txt) sur le bureau ? (O/N)"
    if ($choice -match "^[oO]") {
        $path = "$env:USERPROFILE\Desktop\Config_PC_$pcName.txt"
        $consoleReport | Set-Content -Path $path -Encoding UTF8
        Write-Host "`n Rapport sauvegarde sur le bureau : $path" -ForegroundColor Green
    } else {
        Write-Host "`nRetour au menu." -ForegroundColor Yellow
    }
    Start-Sleep -Seconds 2
}

# ------------------------------------------------------------------------------
# MODULE 2 : INFORMATIONS RESEAU & RDP
# ------------------------------------------------------------------------------
function Invoke-NetworkModule {
    Show-Header
    Write-Host "--- [2] INFORMATIONS RESEAU & CONFIGURATION RDP ---`n" -ForegroundColor Cyan
    Write-Host " INFORMATIONS RDP (Bureau a distance) :" -ForegroundColor Yellow
    Write-Host "Mise a jour en cours, revenez plus tard !`n" -ForegroundColor DarkYellow

    function Get-NetInfo {
        param($adapter)
        if ($adapter) {
            $mac = $adapter.MacAddress
            $ipv4 = (Get-NetIPAddress -InterfaceIndex $adapter.ifIndex -AddressFamily IPv4 -ErrorAction SilentlyContinue | Select-Object -First 1).IPAddress
            return @{ MAC = $mac; IPv4 = $ipv4 }
        }
        return @{ MAC = "N/A"; IPv4 = "N/A" }
    }

    $eth = Get-NetAdapter -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq "Up" -and $_.InterfaceDescription -notmatch "Wi-Fi|Wireless|Radmin" } | Select-Object -First 1
    $wifi = Get-NetAdapter -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq "Up" -and $_.InterfaceDescription -match "Wi-Fi|Wireless" } | Select-Object -First 1

    $ethInfo = Get-NetInfo $eth
    $wifiInfo = Get-NetInfo $wifi
    $pcName = $env:COMPUTERNAME

    $netReport = @"
===========================
    TOOLBOX NETWORK INFO
===========================
PC Name : $pcName

--- Ethernet ---
MAC  : $($ethInfo.MAC)
IPv4 : $($ethInfo.IPv4)

--- Wi-Fi ---
MAC  : $($wifiInfo.MAC)
IPv4 : $($wifiInfo.IPv4)
===========================
"@

    Write-Host $netReport -ForegroundColor Green
    Write-Host "------------------------------------------------------------------" -ForegroundColor DarkGray
    $choice = Read-Host "Voulez-vous enregistrer le rapport reseau (.txt) sur votre bureau ? (O/N)"
    if ($choice -match "^[oO]") {
        $path = "$env:USERPROFILE\Desktop\NETWORK_$pcName.txt"
        $netReport | Set-Content -Path $path -Encoding UTF8
        Write-Host "`n Fichier reseau sauvegarde : $path" -ForegroundColor Green
    }
    Start-Sleep -Seconds 2
}

# ------------------------------------------------------------------------------
# MODULE 3 : BENCHMARK CPU & MEMOIRE (DRAGON SCORE)
# ------------------------------------------------------------------------------
function Invoke-BenchmarkModule {
    Show-Header
    Write-Host "--- [3] BENCHMARK CPU & MEMOIRE (DRAGON SCORE) ---`n" -ForegroundColor Cyan
    Write-Host " Lancement du test de performance..." -ForegroundColor Yellow

    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    1..500000 | ForEach-Object { [math]::Sqrt($_) * [math]::Sin($_) } | Out-Null
    $sw.Stop()
    $cpuTime = $sw.ElapsedMilliseconds

    data:image/svg+xml;utf8,<svg></svg>$sw.Restart()
    $memArray = New-Object System.Collections.ArrayList
    1..200000 | ForEach-Object { $null = $memArray.Add($_) }
    $sw.Stop()
    $ramTime = $sw.ElapsedMilliseconds

    $cpuScore = [math]::Round((1000000 / ($cpuTime + 1)), 0)
    $ramScore = [math]::Round((500000 / ($ramTime + 1)), 0)
    $dragonScore = $cpuScore + $ramScore

    Write-Host "==================================================================" -ForegroundColor Yellow
    Write-Host "                RESULTATS DU BENCHMARK DRAGON SCORE               " -ForegroundColor Yellow
    Write-Host "==================================================================" -ForegroundColor Yellow
    Write-Host " Temps de calcul CPU : $cpuTime ms  --> Score CPU : $cpuScore PTS" -ForegroundColor White
    Write-Host " Temps d'acces RAM   : $ramTime ms  --> Score RAM : $ramScore PTS" -ForegroundColor White
    Write-Host " ----------------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "  DRAGON SCORE GLOBAL : $dragonScore POINTS" -ForegroundColor Cyan -BackgroundColor Black
    Write-Host "==================================================================`n" -ForegroundColor Yellow

    Write-Host "Appuyez sur une touche pour retourner au menu principal..." -ForegroundColor DarkGray
    [System.Console]::ReadKey($true) | Out-Null
}

# ------------------------------------------------------------------------------
# MODULE 4 : MONITEUR EN TEMPS REEL PAR DRAGON
# ------------------------------------------------------------------------------
function Invoke-MonitorModule {
    function Get-ProgressBar ([int]$percent, [int]$width = 20) {
        $filled = [math]::Round(($percent / 100) * $width)
        $empty = $width - $filled
        return "[" + ("=" * $filled) + (" " * $empty) + "]"
    }

    $cpuCounter = New-Object System.Diagnostics.PerformanceCounter("Processor", "% Processor Time", "_Total")
    $null = $cpuCounter.NextValue()

    do {
        Show-Header
        Write-Host "--- [4] MONITEUR EN TEMPS REEL PAR DRAGON ---" -ForegroundColor Cyan
        Write-Host " Actualisation en direct (Appuyez sur [Backspace] pour quitter)`n" -ForegroundColor DarkGray

        $cpuUsage = [math]::Round($cpuCounter.NextValue(), 1)
        $cpuBar = Get-ProgressBar -percent $cpuUsage
        $cpuColor = if ($cpuUsage -gt 85) { "Red" } elseif ($cpuUsage -gt 50) { "Yellow" } else { "Green" }

        $os = Get-CimInstance Win32_OperatingSystem
        $totalRAM = $os.TotalVisibleMemorySize
        $freeRAM = $os.FreePhysicalMemory
        $usedRAM = $totalRAM - $freeRAM
        $ramPercent = [math]::Round(($usedRAM / $totalRAM) * 100, 1)
        $ramBar = Get-ProgressBar -percent $ramPercent
        
        $usedGB = [math]::Round($usedRAM / 1MB, 2)
        $totalGB = [math]::Round($totalRAM / 1MB, 2)

        $uptime = (Get-Date) - $os.LastBootUpTime
        $uptimeStr = "$($uptime.Days)j $($uptime.Hours)h $($uptime.Minutes)m $($uptime.Seconds)s"

        Write-Host " [ PROCESSEUR ]" -ForegroundColor Yellow
        Write-Host " Charge CPU  : $cpuBar $cpuUsage %" -ForegroundColor $cpuColor
        Write-Host ""
        Write-Host " [ MEMOIRE VIVE (RAM) ]" -ForegroundColor Yellow
        Write-Host " Charge RAM  : $ramBar $ramPercent % ($usedGB Go / $totalGB Go)" -ForegroundColor Cyan
        Write-Host ""
        Write-Host " [ SYSTEME ]" -ForegroundColor Yellow
        Write-Host " Uptime PC   : $uptimeStr" -ForegroundColor White
        Write-Host "==================================================================" -ForegroundColor DarkCyan

        $loopCount = 0
        while ($loopCount -lt 15) {
            if ([System.Console]::KeyAvailable) {
                $key = [System.Console]::ReadKey($true)
                if ($key.Key -eq 'Backspace') { return }
            }
            Start-Sleep -Milliseconds 100
            $loopCount++
        }

    } while ($true)
}

# ------------------------------------------------------------------------------
# MODULE 5 : NOUVEAUTES & RESEAUX SOCIAUX
# ------------------------------------------------------------------------------
function Invoke-UpcomingModule {
    Show-Header
    Write-Host "--- [5] NOUVEAUTES & MES RESEAUX SOCIAUX ---`n" -ForegroundColor Cyan
    Write-Host " RETROUVEZ LERDRAGON SUR LES RESEAUX :" -ForegroundColor Yellow
    Write-Host "  - Site Web  : https://lrdfdragon.github.io" -ForegroundColor Cyan
    Write-Host "  - YouTube   : https://www.youtube.com/@LeRDragon" -ForegroundColor Red
    Write-Host "  - Twitch    : https://www.twitch.tv/lerdragon" -ForegroundColor Magenta
    Write-Host "  - Discord   : https://discord.gg/dBha5kxJHV`n" -ForegroundColor Blue

    Write-Host " PROCHAINES MISES A JOUR :" -ForegroundColor Yellow
    Write-Host "  - Mises a jour prevues des le retour en France (19-21 Aout)." -ForegroundColor White
    Write-Host "  - Benchmark etendu (GPU + Vitesse Disque + Ping Reseau)." -ForegroundColor White
    Write-Host "  - Support Multilingue (FR/EN).`n" -ForegroundColor White

    Write-Host "Appuyez sur une touche pour retourner au menu principal..." -ForegroundColor DarkGray
    [System.Console]::ReadKey($true) | Out-Null
}

# ------------------------------------------------------------------------------
# BOUCLE PRINCIPALE ET ECRAN DE FERMETURE
# ------------------------------------------------------------------------------
do {
    Show-Header
    Write-Host "  [1] Detail Config By LeRDragon" -ForegroundColor White
    Write-Host "  [2] Informations Reseau & RDP" -ForegroundColor White
    Write-Host "  [3] Benchmark CPU & Memoire (Dragon Score)" -ForegroundColor White
    Write-Host "  [4] Moniteur en temps reel par Dragon" -ForegroundColor White
    Write-Host "  [5] Nouveautes & Reseaux Sociaux" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  [Backspace] Quitter" -ForegroundColor Red
    Write-Host ""
    Write-Host "==================================================================" -ForegroundColor DarkCyan
    Write-Host -NoNewline " Choisissez un onglet (1-5 ou Backspace) : " -ForegroundColor Yellow

    $keyInfo = [System.Console]::ReadKey($true)

    # Verification si l'utilisateur appuie sur Backspace pour quitter
    if ($keyInfo.Key -eq 'Backspace') {
        break
    }

    $inputKey = $keyInfo.KeyChar.ToString()

    switch ($inputKey) {
        "1" { Invoke-ConfigModule }
        "2" { Invoke-NetworkModule }
        "3" { Invoke-BenchmarkModule }
        "4" { Invoke-MonitorModule }
        "5" { Invoke-UpcomingModule }
    }

} while ($true)

# ------------------------------------------------------------------------------
# ECRAN DE SORTIE SOIGNE
# ------------------------------------------------------------------------------
Clear-Host
Write-Host "==================================================================" -ForegroundColor DarkCyan
Write-Host "             MERCI D'AVOIR UTILISE TOOLBOX BY LERDRAGON           " -ForegroundColor Yellow -BackgroundColor Black
Write-Host "==================================================================" -ForegroundColor DarkCyan
Write-Host "  - Site Web  : https://lrdfdragon.github.io" -ForegroundColor Cyan
Write-Host "  - YouTube   : https://www.youtube.com/@LeRDragon" -ForegroundColor Red
Write-Host "  - Twitch    : https://www.twitch.tv/lerdragon" -ForegroundColor Magenta
Write-Host "  - Discord   : https://discord.gg/dBha5kxJHV" -ForegroundColor Blue
Write-Host "==================================================================" -ForegroundColor DarkCyan
Write-Host "`nA tres bientot pour la suite !`n" -ForegroundColor Green
Start-Sleep -Seconds 3
