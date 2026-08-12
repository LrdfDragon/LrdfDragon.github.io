[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$Host.UI.RawUI.WindowTitle = "DRAGONRIA TOOLBOX v0.6 - BY LERDRAGON"

function Show-Header {
    Clear-Host
    Write-Host "==================================================================" -ForegroundColor DarkCyan
    Write-Host "  TOOLBOX BY LERDRAGON - SYSTEM & NETWORK  " -ForegroundColor Yellow -BackgroundColor Black
    Write-Host "             Version v0.6 [11/08/2026]              " -ForegroundColor Cyan
    Write-Host "==================================================================" -ForegroundColor DarkCyan
}

function Invoke-ConfigModule { Show-Header; Write-Host "Module 1 en cours..." -ForegroundColor Green; Start-Sleep -Seconds 1 }
function Invoke-NetworkModule { Show-Header; Write-Host "Module 2 en cours..." -ForegroundColor Green; Start-Sleep -Seconds 1 }
function Invoke-BenchmarkModule { Show-Header; Write-Host "Module 3 en cours..." -ForegroundColor Green; Start-Sleep -Seconds 1 }
function Invoke-MonitorModule { Show-Header; Write-Host "Module 4 en cours..." -ForegroundColor Green; Start-Sleep -Seconds 1 }
function Invoke-UpcomingModule { Show-Header; Write-Host "Module 5 en cours..." -ForegroundColor Green; Start-Sleep -Seconds 1 }

# BOUCLE PRINCIPALE
$running = $true
while ($running) {
    Show-Header
    Write-Host "  [1] Detail Config"
    Write-Host "  [2] Reseau & RDP"
    Write-Host "  [3] Benchmark"
    Write-Host "  [4] Moniteur Temps Reel"
    Write-Host "  [5] Nouveautes"
    Write-Host ""
    Write-Host "  [Backspace] Pour Quitter" -ForegroundColor Red
    Write-Host "==================================================================" -ForegroundColor DarkCyan
    
    $key = [System.Console]::ReadKey($true)
    
    if ($key.Key -eq 'Backspace') {
        $running = $false
    } else {
        switch ($key.KeyChar.ToString()) {
            "1" { Invoke-ConfigModule }
            "2" { Invoke-NetworkModule }
            "3" { Invoke-BenchmarkModule }
            "4" { Invoke-MonitorModule }
            "5" { Invoke-UpcomingModule }
        }
    }
}
Write-Host "Merci et a bientot !" -ForegroundColor Green
