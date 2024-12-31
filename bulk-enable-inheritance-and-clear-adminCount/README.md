# bulk-enable-inheritance-and-clear-adminCount

PowerShell scripts to clear adminCount and enable inheritance for Active Directory users. These scripts are particularly useful when preparing protected accounts for Azure AD Connect (Entra Connect) synchronization.

## Background

[Protected accounts in Active Directory](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/plan/security-best-practices/appendix-c--protected-accounts-and-groups-in-active-directory) (such as domain admins) have special security settings that prevent modifications to certain attributes. This can cause issues when Entra Connect attempts to write attributes like ms-ds-consistency-guid to protected accounts, resulting in permission error 8344.

These scripts provide a workaround by temporarily clearing the adminCount attribute and enabling inheritance, allowing Entra Connect to modify protected accounts.

## Usage Notes

1. **Security Consideration**: Including admin accounts in sync scope may introduce security risks. Use with caution.
2. **Timing**: Protected accounts will have their adminCount and inheritance settings automatically reset every 60 minutes.
3. **Post-execution**: After running the script, trigger a delta sync manually:
   ```powershell
   Start-ADSyncSyncCycle -PolicyType Delta
4. **Verification**: Check Synchronization Service Manager to confirm that permission errors are resolved.

## Credit

Script Author: Gary Li
