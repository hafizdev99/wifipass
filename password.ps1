# password.ps1 — Wi-Fi bilgi komutu (TR/EN)
# Kullanim: wifipass

Write-Host ""
Write-Host "  Dil secin / Choose language:" -ForegroundColor Cyan
Write-Host "    [1] Turkce"
Write-Host "    [2] English"
Write-Host ""
$sec = Read-Host "  >> "

$tr = @{
    title    = "Wi-Fi Bilgileri"
    name     = "Ag adi        "
    pass     = "Sifre         "
    auth     = "Guvenlik      "
    sig      = "Sinyal        "
    band     = "Band          "
    channel  = "Kanal         "
    mac      = "MAC Adresi    "
    ip       = "IP Adresi     "
    gateway  = "Ag Gecidi     "
    notconn  = "Hicbir Wi-Fi agina baglanilmadi."
    nopass   = "(sifre alinamadi)"
}
$en = @{
    title    = "Wi-Fi Information"
    name     = "Network       "
    pass     = "Password      "
    auth     = "Security      "
    sig      = "Signal        "
    band     = "Band          "
    channel  = "Channel       "
    mac      = "MAC Address   "
    ip       = "IP Address    "
    gateway  = "Gateway       "
    notconn  = "Not connected to any Wi-Fi network."
    nopass   = "(could not retrieve password)"
}

$L = if ($sec -eq "2") { $en } else { $tr }

$iface  = netsh wlan show interfaces
$ssid   = ($iface | Select-String "^\s+SSID\s+:"   | Select-Object -First 1) -replace ".*:\s*",""
$ssid   = $ssid.Trim()

if (-not $ssid) {
    Write-Host ""
    Write-Host "  $($L.notconn)" -ForegroundColor Red
    Write-Host ""
    exit
}

$auth    = ($iface | Select-String "Authentication" | Select-Object -First 1) -replace ".*:\s*",""
$signal  = ($iface | Select-String "Signal"         | Select-Object -First 1) -replace ".*:\s*",""
$band    = ($iface | Select-String "Radio type"     | Select-Object -First 1) -replace ".*:\s*",""
$channel = ($iface | Select-String "Channel"        | Select-Object -First 1) -replace ".*:\s*",""
$mac     = ($iface | Select-String "Physical address" | Select-Object -First 1) -replace ".*:\s*",""

# IP ve Gateway
$ipInfo  = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -like "*Wi-Fi*" -or $_.InterfaceAlias -like "*Wireless*" } | Select-Object -First 1
$ip      = $ipInfo.IPAddress
$gw      = (Get-NetRoute -DestinationPrefix "0.0.0.0/0" | Sort-Object RouteMetric | Select-Object -First 1).NextHop

# Sifre
$pwd = (netsh wlan show profile name="$ssid" key=clear 2>&1 |
        Select-String "Key Content") -replace ".*:\s*",""
if (-not $pwd) { $pwd = $L.nopass }

Write-Host ""
Write-Host "  ========================================" -ForegroundColor Cyan
Write-Host "    $($L.title)"                            -ForegroundColor Cyan
Write-Host "  ========================================" -ForegroundColor Cyan
Write-Host "  $($L.name): $ssid"     -ForegroundColor Yellow
Write-Host "  $($L.pass): $pwd"      -ForegroundColor Green
Write-Host "  $($L.auth): $auth"
Write-Host "  $($L.sig) : $signal"
Write-Host "  $($L.band): $band"
Write-Host "  $($L.channel): $channel"
Write-Host "  $($L.mac): $mac"
Write-Host "  $($L.ip) : $ip"
Write-Host "  $($L.gateway): $gw"
Write-Host ""
