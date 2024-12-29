# Entra Connect Tools

A collection of PowerShell scripts and tools for managing Microsoft Entra Connect (formerly Azure AD Connect) and related infrastructure. This repository contains utilities for common administrative tasks and troubleshooting scenarios.

## Repository Structure

* **ad-thumbnailPhoto-writer**: Scripts for managing AD thumbnail photos
  * `resize96x96-writer.ps1`: Resizes and writes thumbnail photos to AD with 96x96 dimensions
  * `simple-writer.ps1`: Direct thumbnail photo writer without resizing

* **bulk-disable-sms-signin**: Tools for managing SMS sign-in authentication
  * `bulk-disable-sms-signin.ps1`: Script to disable SMS sign-in for multiple users

* **bulk-hard-match**: Identity matching utilities
  * `bulk-hard-match-guid-to-immutableid.ps1`: Convert and match GUIDs to immutableIDs for multiple users

* **install-exchange-server**: Exchange Server deployment tools
  * `Exchange2019-PreReqScript-1.19.ps1`: Prerequisites checker for Exchange Server 2019 installation

## Prerequisites

* PowerShell 5.1 or higher
* Appropriate administrative permissions for Active Directory and Microsoft Entra
* [Microsoft Graph PowerShell SDK](https://learn.microsoft.com/en-us/powershell/microsoftgraph/installation?view=graph-powershell-1.0)

## Usage

Each folder contains specific tools with their own documentation. Please refer to individual folder README files for detailed usage instructions and prerequisites.

## Contributing

Feel free to submit issues, fork the repository, and create pull requests for any improvements.

## Credits

* Scripts are developed by me and my friends and contributors for Entra Connect management tasks
* Exchange Server 2019 prerequisites script sourced from [PowerShell Geek](https://www.powershellgeek.com/powershell-scripts/)

## Disclaimer

These tools are provided as-is without any warranty. Always test in a non-production environment before use.

## License

This project is licensed under the MIT License. See the LICENSE file for details.
