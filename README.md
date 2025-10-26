# Entra Connect Tools

PowerShell scripts and utilities for managing Microsoft Entra Connect (formerly Azure AD Connect) and related infrastructure.

## Quick Navigation

| Name | Tag |
|------|-----|
| [ad-thumbnailPhoto-writer](ad-thumbnailPhoto-writer) | on-premise, user, attributes |
| [bulk-create-cloud-groups](bulk-create-cloud-groups) | entra-id, group, bulk |
| [bulk-create-users](bulk-create-users) | on-premise, user, bulk |
| [bulk-disable-sms-signin](bulk-disable-sms-signin) | entra-id, user, authentication, bulk |
| [bulk-enable-inheritance-and-clear-adminCount](bulk-enable-inheritance-and-clear-adminCount) | on-premise, user, permissions, sync, entra-connect |
| [bulk-hard-match](bulk-hard-match) | hybrid, user, bulk, identity-matching, entra-connect |
| [group-member-exporter](group-member-exporter) | entra-id, group, reporting |
| [install-exchange-server](install-exchange-server) | on-premise, exchange |
| [sync-device-extensionAttribute](sync-device-extensionAttribute) | hybrid, device, sync, attributes |

## Prerequisites

* PowerShell 5.1 or higher
* Appropriate administrative permissions for Active Directory and Microsoft Entra
* [Microsoft Graph PowerShell SDK](https://learn.microsoft.com/en-us/powershell/microsoftgraph/installation?view=graph-powershell-1.0)

## Usage

Each folder contains specific tools with their own documentation. Refer to individual folder README files for detailed usage instructions.

## Contributing

Feel free to submit issues, fork the repository, and create pull requests for improvements.

## Credits

* Scripts are developed by me and my friends and contributors for Entra Connect management tasks
* Exchange Server 2019 prerequisites script sourced from [PowerShell Geek](https://www.powershellgeek.com/powershell-scripts/)

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Disclaimer

These tools are provided as-is without warranty. Always test in a non-production environment before use.
