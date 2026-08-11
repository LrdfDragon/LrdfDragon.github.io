# ==========================================
#   DRAGONRIA TOOLBOX - VERSION 0.6
#   Auteur: LeRDragon
# ==========================================

$Host.UI.RawUI.WindowTitle = "Dragonria Toolbox v0.6 - System & Network"

function Show-Header {
    Clear-Host
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host "            DRAGONRIA TOOLBOX v0.6               " -ForegroundColor Yellow
    Write-Host "   System & Network Interactive Management Tool  " -ForegroundColor Cyan
    Write-Host "==================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Show-Menu {
    Show-Header
    Write-Host " [1] 💻 Diagnostic System (CPU, GPU, RAM, Disques)" -ForegroundColor Green
    Write-Host " [2] 🌐 Configuration Réseau & Adresses IP" -ForegroundColor Green
    Write-Host " [3] 🖥️  Gestion accès à distance (RDP)" -ForegroundColor Green
    Write-Host " [4] ⚡ Dragon Score Bench (Benchmark Périphériques)" -ForegroundColor Green
    Write-Host " [5] ❌ Quitter" -ForegroundColor Red
    Write-Host ""
    Write-Host "Utilisez les flèches [↑/↓], les chiffres [1-5] ou Entrée pour valider." -ForegroundColor Gray
}

function Invoke-SystemDiag {
    Show-Header
    Write-Host "--- DIAGNOSTIC SYSTEME ---" -ForegroundColor Yellow
    
    $cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
    $ram = Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
    $ramGb = [math]::Round($ram.Sum / 1GB, 2)
    $gpu = Get-CimInstance Win32_VideoController | Select-Object -First 1
    
    Write-Host "Processeur : $($cpu.Name)" -ForegroundColor White
    Write-Host "Cœurs / Threads : $($cpu.NumberOfCores) / $($cpu.NumberOfLogicalProcessors)" -ForegroundColor White
    Write-Host "Mémoire RAM Total : $ramGb GB" -ForegroundColor White
    Write-Host "Carte Graphique : $($gpu.Name)" -ForegroundColor White
    
    Write-Host "`n--- STOCKAGE ---" -ForegroundColor Yellow
    Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | ForEach-Object {
        $free = [math]::Round($_.FreeSpace / 1GB, 2)
        $total = [math]::Round($_.Size / 1GB, 2)
        Write-Host "Disque $($_.DeviceID) - Libres : $free GB / Total : $total GB" -ForegroundColor White
    }
    
    Write-Host "`nAppuyez sur une touche pour revenir au menu..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Invoke-NetworkDiag {
    Show-Header
    Write-Host "--- CONFIGURATION RESEAU ---" -ForegroundColor Yellow
    
    Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notlike "*Loopback*" } | ForEach-Object {
        Write-Host "Interface : $($_.InterfaceAlias)" -ForegroundColor Cyan
        Write-Host "  Adresse IP : $($_.IPAddress)" -ForegroundColor White
        Write-Host "  Masque     : $($_.PrefixLength)" -ForegroundColor White
    }
    
    Write-Host "`n--- TEST D'ACCES INTERNET ---" -ForegroundColor Yellow
    if (Test-Connection -ComputerName 8.8.8.8 -Count 1 -Quiet) {
        Write-Host "Statut : Connecté à Internet (Ping OK)" -ForegroundColor Green
    } else {
        Write-Host "Statut : Pas d'accès Internet" -ForegroundColor Red
    }
    
    Write-Host "`nAppuyez sur une touche pour revenir au menu..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Invoke-RdpManager {
    Show-Header
    Write-Host "--- GESTION DU BUREAU A DISTANCE (RDP) ---" -ForegroundColor Yellow
    
    $rdpStatus = (Get-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server').fDenyTSConnections
    if ($rdpStatus -eq 0) {
        Write-Host "Statut actuel : RDP Activé" -ForegroundColor Green
    } else {
        Write-Host "Statut actuel : RDP Désactivé" -ForegroundColor Red
    }
    
    Write-Host "`n [1] Activer le RDP"
    Write-Host " [2] Désactiver le RDP"
    Write-Host " [3] Retour au menu principal"
    
    $choice = Read-Host "`nVotre choix"
    switch ($choice) {
        "1" {
            Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0
            Enable-NetFirewallRule -DisplayGroup "Remote Desktop" -ErrorAction SilentlyContinue
            Write-Host "RDP Activé avec succès !" -ForegroundColor Green
            Start-Sleep -Seconds 2
        }
        "2" {
            Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 1
            Write-Host "RDP Désactivé !" -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
}

function Invoke-DragonScore {
    Show-Header
    Write-Host "--- DRAGON SCORE BENCH ---" -ForegroundColor Yellow
    Write-Host "Calcul du score CPU en cours..." -ForegroundColor Gray
    
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    1..5000000 | ForEach-Object { $null = $_ * $_ }
    $sw.Stop()
    
    $score = [math]::Round(1000000 / $sw.ElapsedMilliseconds)
    Write-Host "`nScore Dragonria CPU : $score Pts" -ForegroundColor Yellow
    
    Write-Host "`nAppuyez sur une touche pour revenir au menu..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# --- BOUCLE PRINCIPALE INTERACTIVE ---
$selectedIndex = 0
$optionsCount = 5

do {
    Show-Menu
    
    # Positionnement du curseur pour la sélection
    $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    
    switch ($key.VirtualKeyCode) {
        38 { # Flèche Haut
            $selectedIndex = ($selectedIndex - 1 + $optionsCount) % $optionsCount
        }
        40 { # Flèche Bas
            $selectedIndex = ($selectedIndex + 1) % $optionsCount
        }
        13 { # Entrée
            switch ($selectedIndex) {
                0 { Invoke-SystemDiag }
                1 { Invoke-NetworkDiag }
                2 { Invoke-RdpManager }
                3 { Invoke-DragonScore }
                4 { exit }
            }
        }
        # Support des touches numérotées (chiffres du haut & pavé numérique)
        { $_ -in 49,97 } { Invoke-SystemDiag }
        { $_ -in 50,98 } { Invoke-NetworkDiag }
        { $_ -in 51,99 } { Invoke-RdpManager }
        { $_ -in 52,100 } { Invoke-DragonScore }
        { $_ -in 53,101 } { exit }
    }
} while ($true)
