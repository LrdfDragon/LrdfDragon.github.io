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
    Write-Host "  - Températures CPU/GPU + Fréquence de rafraîchissement" -ForegroundColor DarkMagenta
    Write-Host "  - Correction du bug d'ouverture/fermeture rapide en Admin" -ForegroundColor DarkMagenta
    Write-Host "  - Onglet 5 : Mes Réseaux Sociaux & Support Multilingue (FR/EN)" -ForegroundColor DarkMagenta
    Write-Host "================================================================================" -ForegroundColor DarkCyan
}

Show-Header

Write-Host "`n[1] Detail Config By LeRDragon" -ForegroundColor White
Write-Host "[2] Informations Reseau & RDP" -ForegroundColor White
Write-Host "[3] Benchmark CPU & Memoire (Dragon Score)" -ForegroundColor White
Write-Host "[4] Moniteur en temps reel par Dragon" -ForegroundColor White
Write-Host "[5] Nouveautes & Reseaux Sociaux" -ForegroundColor Cyan
Write-Host "`n[Q] Quitter" -ForegroundColor Red
Write-Host "================================================================================" -ForegroundColor DarkCyan

$choice = Read-Host "`nChoisissez un onglet (1-5 ou Q)"
