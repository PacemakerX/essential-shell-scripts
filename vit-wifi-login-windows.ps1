[Console]::CursorVisible = $false

# Config
# WiFi network name to connect to (G-VIT,E-VIT,L-VIT)
$wifiSSID = "WIFI_SSID"
# Username for captive portal authentication
$USERNAME = "YOUR_USERNAME"  
# Password for captive portal authentication
$PASSWORD = "YOUR_PASSWORD"
$LOGIN_URL = "http://phc.prontonetworks.com/cgi-bin/authlogin?URI=http://detectportal.firefox.com/canonical.html"

# Spinner Function
function Show-Spinner {
    param([int]$Duration = 3)
    $spinner = "|/-\"
    for ($i = 0; $i -lt ($Duration * 10); $i++) {
        Write-Host -NoNewline ("`r[{0}]" -f $spinner[$i % $spinner.Length])
        Start-Sleep -Milliseconds 100
    }
    Write-Host "`r    " -NoNewline
}

# Get connected SSID
function Get-ConnectedSSID {
    $output = netsh wlan show interfaces
    $match = ($output | Select-String '^\s*SSID\s*:\s*(.+)$')
    if ($match) {
        return ($match.Matches.Groups[1].Value.Trim())
    }
    return $null
}

# Connect to WiFi
function Connect-ToWiFi {
    Write-Host "Connecting to Wi-Fi: $wifiSSID ..."
    netsh wlan connect name="$wifiSSID" | Out-Null
    Start-Sleep -Seconds 4
    $ssid = Get-ConnectedSSID
    if ($ssid -ieq $wifiSSID) {
        return $true
    }
    return $false
}

# Detect Captive Portal (Windows-independent)
function NeedsLogin {
    try {
        $response = Invoke-WebRequest -Uri "http://detectportal.firefox.com/success.txt" -UseBasicParsing -TimeoutSec 5
        return ($response.StatusCode -ne 200 -or $response.Content.Trim() -ne "success")
    } catch {
        return $true
    }
}

# Main
if (-not (Connect-ToWiFi)) {
    Write-Host "Could not verify Wi-Fi connection. Proceeding anyway..."
}

if (NeedsLogin) {
    Write-Host "Attempting to log in to the captive portal..."
    try {
        Invoke-WebRequest -Uri $LOGIN_URL -Method POST -Body @{
            "userId"      = $USERNAME
            "password"    = $PASSWORD
            "serviceName" = "ProntoAuthentication"
        } -UseBasicParsing -TimeoutSec 10 | Out-Null

        Show-Spinner -Duration 2
        Write-Host "`nConnected successfully without browser pop-up!"
    } catch {
        Write-Host "Login failed. Please check your credentials or network."
    }
} else {
    Write-Host "Already connected. No captive portal detected."
}

[Console]::CursorVisible = $true