[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# ==============================================================================
# DRAGONRIA TOOLBOX v0.6
# ==============================================================================

function Show-Header {
    Clear-Host
    Write-Host "================================================================================" -ForegroundColor DarkCyan
    Write-Host "                      TOOLBOX BY LERDRAGON - SYSTEM & NETWORK                    " -ForegroundColor Yellow
    Write-Host "                              Version v0.6 [11/08/2026]                         " -ForegroundColor Cyan
    Write-Host "================================================================================" -ForegroundColor DarkCyan
    
    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if ($isAdmin) {
        Write-Host "[OK] Mode Administrateur Actif" -ForegroundColor Green
    } else {
        Write-Host "[!] Mode Utilisateur Standard (Certaines fonctions necessitent l'Admin)" -ForegroundColor Yellow
    }
    
    Write-Host "`n* HISTORIQUE DES MISES A JOUR :" -ForegroundColor Gray
    Write-Host "  - v0.1 [01/08/2026] : Module Config System + Export .txt" -ForegroundColor DarkGray
    Write-Host "  - v0.2 [03/08/2026] : Module Reseau & RDP interactif + Menu TUI" -ForegroundColor DarkGray
    Write-Host "  - v0.3 [06/08/2026] : Integration Benchmark Dragon Score" -ForegroundColor DarkGray
    Write-Host "  - v0.4 [08/08/2026] : Moniteur Temps Reel optimise (sans lag HDD)" -ForegroundColor DarkGray
    Write-Host "  - v0.5 [10/08/2026] : Lancement/Fermeture & Integration Reseaux LeRDragon" -ForegroundColor DarkGray
    Write-Host "  - v0.6 [11/08/2026] : Lancement Officiel du Site Web & Correction Encodage" -ForegroundColor Green

    Write-Host "`n* PROCHAINES MAJ PREVUES :" -ForegroundColor Magenta
    Write-Host "  - Multi-GPU/Disque/Ping dans le Bench + Note de Perf" -ForegroundColor DarkMagenta
    Write-Host "  - Temperatues CPU/GPU + Frequence de rafraichissement" -ForegroundColor DarkMagenta
    Write-Host "  - Correction du bug d'ouverture/fermeture rapide en Admin" -ForegroundColor DarkMagenta
    Write-Host "  - Onglet 5 : Mes Reseaux Sociaux & Support Multilingue (FR/EN)" -ForegroundColor DarkMagenta
    Write-Host "================================================================================" -ForegroundColor DarkCyan
}


# ==============================================================================
# BOUCLE PRINCIPALE DU MENU
# ==============================================================================

do {
    Show-Header

    Write-Host "`n[1] Detail Config By LeRDragon" -ForegroundColor White
    Write-Host "[2] Informations Reseau & RDP" -ForegroundColor White
    Write-Host "[3] Benchmark CPU & Memoire (Dragon Score)" -ForegroundColor White
    Write-Host "[4] Moniteur en temps reel par Dragon" -ForegroundColor White
    Write-Host "[5] Nouveautes & Reseaux Sociaux" -ForegroundColor Cyan
    Write-Host "`n[Q] Quitter" -ForegroundColor Red
    Write-Host "================================================================================" -ForegroundColor DarkCyan

    $choice = Read-Host "`nChoisissez un onglet (1-5 ou Q)"

    switch ($choice) {
        "1" {
            Clear-Host
            Write-Host "--- DETAIL CONFIG ---" -ForegroundColor Yellow
            # Insère ici la fonction ou le code de la config
            Pause
        }
        "2" {
            Clear-Host
            Write-Host "--- RESEAU & RDP ---" -ForegroundColor Yellow
            # Insère ici la fonction ou le code du réseau
            Pause
        }
        "3" {
            Clear-Host
            Write-Host "--- BENCHMARK DRAGON SCORE ---" -ForegroundColor Yellow
            # Insère ici la fonction ou le code du benchmark
            Pause
        }
        "4" {
            Clear-Host
            Write-Host "--- MONITEUR TEMPS REEL ---" -ForegroundColor Yellow
            # Insère ici la fonction ou le code du moniteur
            Pause
        }
        "5" {
            Clear-Host
            Write-Host "--- NOUVEAUTES & RESEAUX SOCIAUX ---" -ForegroundColor Cyan
            Write-Host "Retrouvez-moi sur le site : https://lrdfdragon.github.io" -ForegroundColor White
            Pause
        }
        "Q" {
            Write-Host "`nA bientot !" -ForegroundColor Green
            Start-Sleep -Seconds 1
        }
        "q" {
            Write-Host "`nA bientot !" -ForegroundColor Green
            Start-Sleep -Seconds 1
        }
        default {
            Write-Host "`nChoix invalide, reessayez..." -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }

} while ($choice -ne "Q" -and $choice -ne "q")
