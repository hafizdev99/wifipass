# password.ps1 — Wi-Fi bilgi komutu (TR/EN)
# Kullanim: irm bit.ly/wifipassps1 | iex

Write-Host ""
Write-Host "  Dil secin / Choose language:" -ForegroundColor Cyan
Write-Host "    [1] Turkce"
Write-Host "    [2] English"
Write-Host ""
$sec = Read-Host "  >> "

$tr = @{
    title   = "Wi-Fi Bilgileri"
    name    = "Ag adi   "
    pass    = "Sifre    "
    sec     = "Guvenlik "
    sig     = "Sinyal   "
    notconn = "Hicbir Wi-Fi agina baglanilmadi."
    nopass  = "(sifre alinamadi)"
}
$en = @{
    title   = "Wi-Fi Information"
    name    = "Network  "
    pass    = "Password "
    sec     = "Security "
    sig     = "Signal   "
    notconn = "Not connected to any Wi-Fi network."
    nopass  = "(could not retrieve password)"
}

$L = if ($sec -eq "2") { $en } else { $tr }

$iface  = netsh wlan show interfaces
$ssid   = ($iface | Select-String "^\s+SSID\s+:" | Select-Object -First 1) -replace ".*:\s*",""
$ssid   = $ssid.Trim()

if (-not $ssid) {
    Write-Host ""
    Write-Host "  $($L.notconn)" -ForegroundColor Red
    Write-Host ""
    exit
}

$auth   = ($iface | Select-String "Authentication" | Select-Object -First 1) -replace ".*:\s*",""
$signal = ($iface | Select-String "Signal"         | Select-Object -First 1) -replace ".*:\s*",""
$pwd    = (netsh wlan show profile name="$ssid" key=clear 2>&1 |
           Select-String "Key Content") -replace ".*:\s*",""

if (-not $pwd) { $pwd = $L.nopass }

Write-Host ""
Write-Host "  ================================" -ForegroundColor Cyan
Write-Host "    $($L.title)"                    -ForegroundColor Cyan
Write-Host "  ================================" -ForegroundColor Cyan
Write-Host "  $($L.name) : $ssid"              -ForegroundColor Yellow
Write-Host "  $($L.pass) : $pwd"               -ForegroundColor Green
Write-Host "  $($L.sec)  : $auth"
Write-Host "  $($L.sig)  : $signal"
Write-Host ""
