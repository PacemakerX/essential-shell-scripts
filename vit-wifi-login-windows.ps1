# Hide the cursor (not directly possible in PowerShell, but can be ignored)

# Wi-Fi connection (Make sure the SSID is correct)
$wifiSSID = "YOUR_WIFI_SSID" # <----- INSERT YOUR WIFI SSID HERE (wifi name e.g. G-VIT,E-VIT,J-VIT)

# Check if the Wi-Fi profile exists
$wifiProfile = netsh wlan show profiles | Select-String $wifiSSID

if (-not $wifiProfile) {
    Write-Host "Connecting to Wi-Fi: $wifiSSID..."
    netsh wlan connect name="$wifiSSID"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to connect to Wi-Fi '$wifiSSID'. Please ensure the SSID is correct and you are in range."
        exit 1
    }
    Start-Sleep -Seconds 5
} else {
    Write-Host "Wi-Fi profile '$wifiSSID' found."
}

# Replace with your credentials - HARDCODED (USE WITH CAUTION!)
$USERNAME = "YOUR_USERNAME" # <----- INSERT YOUR USERNAME HERE
$PASSWORD = "YOUR_PASSWORD" # <----- INSERT YOUR PASSWORD HERE

# URL for login submission
$LOGIN_URL = "http://phc.prontonetworks.com/cgi-bin/authlogin?URI=http://detectportal.firefox.com/canonical.html"

# Function to show a spinner
function Show-Spinner {
    param(
        [int]$Duration = 5
    )
    $spinner = "|/-\\"
    $i = 0
    $start = Get-Date
    while ((Get-Date) -lt $start.AddSeconds($Duration)) {
        Write-Host -NoNewline "`r[$($spinner[$i % $spinner.Length])] "
        Start-Sleep -Milliseconds 100
        $i++
    }
    Write-Host "  " -NoNewline
}

# Attempt login
Write-Host "Attempting to log in..."
try {
    $response = Invoke-WebRequest -Uri $LOGIN_URL -Method Post -Body @{ "userId" = $USERNAME; "password" = $PASSWORD; "serviceName" = "ProntoAuthentication" } -UseBasicParsing -TimeoutSec 10
    # You might add checks on $response.StatusCode or $response.Content here for more robust login detection
    Show-Spinner -Duration 3
    Write-Host "Connected to the network successfully!"
} catch {
    Write-Host "Failed to connect to the network. Please check your credentials or network connection."
    Write-Error $_ # Output the specific error
}