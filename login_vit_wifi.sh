
#!/bin/bash

# Hide the cursor
tput civis

# Connect to Wi-Fi network
nmcli dev wifi connect G-VIT

# Replace with your credentials
USERNAME="your_username"
PASSWORD="your_password"

# URL for login submission
LOGIN_URL="http://phc.prontonetworks.com/cgi-bin/authlogin?URI=http://detectportal.firefox.com/canonical.html"

# Spinner function for a progress bar
spinner() {
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep "$pid")" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Make the login request silently
echo "Connecting to the network..."
{
    curl -X POST "$LOGIN_URL" \
        -d "userId=$USERNAME" \
        -d "password=$PASSWORD" \
        -d "serviceName=ProntoAuthentication" \
        -s -o /dev/null &
    spinner
} && echo "Connected successfully!" || echo "Failed to connect. Please check your credentials or network."

# Show the cursor again
tput cnorm
