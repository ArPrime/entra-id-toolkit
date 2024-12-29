# Install Exchange Server

## How to Install Exchange Mailbox servers
1. Run the Exchange Prerequisites Check Script and select option 1
2. Download the [latest version of Exchange 2019](https://learn.microsoft.com/en-us/exchange/new-features/updates?view=exchserver-2019)
3. Install Exchange Mailbox servers [using the Setup wizard](https://learn.microsoft.com/en-us/exchange/plan-and-deploy/deploy-new-installations/install-mailbox-role?view=exchserver-2019)

## About Exchange Prerequisites Check Script

The Exchange Prerequisites Check script (`Exchange2019-PreReqScript-1.19.ps1`) helps automate the verification and installation of required components for Exchange Server 2019/2022 deployment.

### Features

- Supports both Windows Server 2019 and 2022
- Handles both Core and Full OS installations
- Verifies and installs prerequisites for:
  - Mailbox Role
  - Edge Transport Role
- Performs comprehensive system checks including:
  - .NET Framework version verification
  - Required Windows features
  - C++ Runtime components
  - UCMA 4.0
  - Power settings
  - TCP/IP settings
  - TLS configuration
  - Windows Defender exclusions

### Requirements

- Windows Server 2019 or 2022 (Core or Full installation)
- PowerShell 5.1 or later
- Administrative privileges
- Internet connectivity for downloading components

### Common Tasks

#### Installing Prerequisites for New Mailbox Role
1. Run the script
2. Select option 1 from the main menu
3. Wait for all components to install
4. Restart the server when prompted

#### Verifying Existing Installation
1. Run the script
2. Select option 10 (Mailbox) or 11 (Edge Transport) for prerequisite checks
3. Review the results

### Original Author

This script is created and maintained by:
- **Author**: Damian Scoles
- **Website**: [PowerShell Geek](https://www.powershellgeek.com/powershell-scripts/)
- **Version**: 1.19 (Last Update: 07/19/2023)

No modifications have been made to the original script. This folder only provides easy access to the script as part of the Entra Connect tools collection.
