# Bulk Disable SMS Sign-in Script

## Background

This script is designed to help administrators bulk disable SMS sign-in for multiple users in Microsoft Entra ID (formerly Azure AD). It addresses a specific issue where users with SMS sign-in enabled are skipped during cross-tenant synchronization.

## Problem Statement

According to [Microsoft's official documentation](https://learn.microsoft.com/en-us/entra/identity/multi-tenant-organizations/cross-tenant-synchronization-configure#symptom---users-are-skipped-because-sms-sign-in-is-enabled-on-the-user), users with SMS sign-in enabled will be skipped by the provisioning service during synchronization. This occurs because the scoping step includes a filter that excludes users with alternative security IDs.

> If SMS sign-in is enabled for a user, they will be skipped by the provisioning service.

> The scoping step includes the following filter with status false: "Filter external users.alternativeSecurityIds EQUALS 'None'"


## Solution

This PowerShell script provides an automated solution to:
1. Read a list of user UPNs (User Principal Names) from your txt file
2. Check their SMS sign-in status
3. Disable SMS sign-in if it's enabled
4. Log the results of the operation

## Prerequisites

- Microsoft.Graph PowerShell modules:
Install-Module Microsoft.Graph.Users.Actions
Install-Module Microsoft.Graph.Identity.SignIns
