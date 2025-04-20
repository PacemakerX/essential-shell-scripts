# ----- CONFIGURATION -----
$wifiSSID = "WIFI_NAME"        # <----- INSERT YOUR WIFI SSID HERE (e.g. G-VIT, E-VIT, J-VIT)
$USERNAME = "YOUR_USERNAME"    # <----- INSERT YOUR USERNAME HERE
$PASSWORD = "YOUR_PASSWORD"     # <----- INSERT YOUR PASSWORD HERE
$LOGIN_URL = "http://phc.prontonetworks.com/cgi-bin/authlogin?URI=http://detectportal.firefox.com/canonical.html"

# ----- FUNCTION: GET CONNECTED SSID -----
function Get-ConnectedSSID {
    $interfaceInfo = netsh wlan show interfaces
    $ssidLine = $interfaceInfo | Select-String '^\s*SSID\s*:\s*(.+)$'
    if ($ssidLine) {
        $ssid = ($ssidLine -replace '^\s*SSID\s*:\s*', '').Trim()
        if ($ssid -and $ssid -ne 'SSID') {
            return $ssid
        }
    }
    return $null
}

# ----- FUNCTION: CONNECT TO WIFI -----
function Connect-ToWiFi {
    Write-Host "Attempting to connect to Wi-Fi: $wifiSSID..."
    $maxAttempts = 3
    for ($i = 1; $i -le $maxAttempts; $i++) {
        netsh wlan connect name="$wifiSSID" | Out-Null

        $currentSSID = Get-ConnectedSSID
        if ($currentSSID -and ($currentSSID.Trim().ToLower() -eq $wifiSSID.ToLower())) {
            Write-Host "Connected to Wi-Fi: $wifiSSID"
            return $true
        } else {
            Write-Host "Attempt $i/$maxAttempts failed to connect."
        }
    }

    Write-Error "Failed to connect to '$wifiSSID' after multiple attempts."
    return $false
}

# ----- FUNCTION: SPINNER (NO DELAY) -----
function Show-Spinner {
    param([int]$Duration = 5)
    $spinner = "|/-\\"
    for ($i = 0; $i -lt ($Duration * 10); $i++) {
        Write-Host -NoNewline "`r[$($spinner[$i % $spinner.Length])] "
    }
    Write-Host "`r   " -NoNewline
}

# ----- MAIN EXECUTION -----
$currentSSID = Get-ConnectedSSID

if ($currentSSID -and ($currentSSID.Trim().ToLower() -eq $wifiSSID.ToLower())) {
    Write-Host "Already connected to '$wifiSSID'."
} else {
    $connected = Connect-ToWiFi
    if (-not $connected) {
        exit 1
    }
}

# ----- LOGIN REQUEST -----
Write-Host "Attempting to log in to the captive portal..."

try {
    $null = Invoke-WebRequest -Uri $LOGIN_URL -Method Post -Body @{
        "userId"      = $USERNAME
        "password"    = $PASSWORD
        "serviceName" = "ProntoAuthentication"
    } -UseBasicParsing -TimeoutSec 10

    Show-Spinner -Duration 3
    Write-Host "`nConnected to the network successfully!"
} catch {
    Write-Host "Failed to connect to the network. Please check your credentials or network status."
    Write-Error $_
}
