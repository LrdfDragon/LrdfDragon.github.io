# Définition de l'encodage
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$Host.UI.RawUI.WindowTitle = "DRAGONRIA TOOLBOX v0.6 - BY LERDRAGON"
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

function Show-Header {
    Clear-Host
    Write-Host "==================================================================" -ForegroundColor DarkCyan
    Write-Host "  TOOLBOX BY LERDRAGON - SYSTEM & NETWORK  " -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "             Version v0.6 [11/08/2026]              " -ForegroundColor Cyan
    Write-Host "==================================================================" -ForegroundColor DarkCyan
    
    if (-not $isAdmin) {
        Write-Host "  Mode Utilisateur Standard (Certaines fonctions necessitent l'Admin)" -ForegroundColor DarkYellow
    } else {
        Write-Host "  Mode Administrateur Actif" -ForegroundColor Green
    }
    Write-Host "------------------------------------------------------------------" -ForegroundColor DarkGray
}

# BOUCLE PRINCIPALE
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

    $key = [System.Console]::ReadKey($true)
    
    if ($key.Key -eq 'Backspace') { break }

    switch ($key.KeyChar.ToString()) {
        "1" { Invoke-ConfigModule }
        "2" { Invoke-NetworkModule }
        "3" { Invoke-BenchmarkModule }
        "4" { Invoke-MonitorModule }
        "5" { Invoke-UpcomingModule }
    }

} while ($true)

Clear-Host
Write-Host "Merci d'avoir utilise la Toolbox ! A bientot." -ForegroundColor Green
