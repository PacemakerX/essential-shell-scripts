# Essential Scripts

<img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRGgsPzv-uJrs767nxk4lAny31yHliWNCnEYg&st=10" alt="Shell Scripting Made Easy" style="width: 100%;"/>


This repository contains a collection of essential scripts to automate various tasks and improve productivity.

## Features

- A variety of scripts to handle different tasks.
- Easy to use and customize.
- Well-documented and maintained.

## Scripts Included

1. **Wi-Fi Auto-Login Script**
   - Automates the process of logging into captive portals.
   - Connects to specified Wi-Fi networks and submits credentials.
   - **Works for both Linux and macOS** using the same script (`vit-wifi-login.sh`).
   - For **Windows**, a separate PowerShell script is available (`vit-wifi-login-windows.ps1`).

## Requirements

1. **Linux System** with necessary tools installed.
   - `nmcli` for network management.
   - `curl` for web requests.
  
2. **Windows**:
    - PowerShell 5.1 or later.

## Setup Instructions

### Step 1: Clone or Download the Repository

Clone this repository or download the scripts to your local machine.
   
   ```bash
   git clone https://github.com/PacemakerX/essential-shell-scripts.git
   cd essential-shell-scripts
   ```

### Step 2: Configure the Scripts

Edit the configuration files to suit your needs. Each script has its own configuration file with detailed instructions.

#### For Linux/macOS:

1. **Make the script executable**:

   ```bash
   chmod +x login_vit_wifi.sh
   ```

2. **Run the script**:
   ```bash
   ./login_vit_wifi.sh
   ```

#### For Windows:

1. **Open PowerShell as Administrator**:

   - Press `Win + X` and select **Windows PowerShell (Admin)** or **Command Prompt (Admin)**.

2. **Allow script execution** (if not already enabled):

   - Run the following command to allow scripts to be executed in PowerShell:
     ```powershell
     Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
     ```

3. **Run the script**:

   - Execute the script:
     ```powershell
     .\vit-wifi-login-windows.ps1
     ```

The script will attempt to connect to the specified Wi-Fi network (e.g., `G-VIT`) and automatically log in to the captive portal.

**Note**: Ensure you have an active internet connection and that your Wi-Fi network is accessible.

## Contributing

Feel free to contribute to this repository by submitting pull requests, reporting issues, or suggesting new features.

## Feel free to connect with me!

<p align="center">
    <a href="mailto:sparsh.officialwork@gmail.com">
        <img src="https://img.shields.io/badge/Gmail-sparsh.officialwork@gmail.com-D14836?style=for-the-badge&logo=gmail&logoColor=white" alt="Gmail Badge" />
    </a>
    <a href="https://www.linkedin.com/in/sparshsoni">
        <img src="https://img.shields.io/badge/LinkedIn-Connect-blue?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn Badge" />
    </a>
</p>
