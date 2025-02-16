# Group Member Exporter

A PowerShell script to export all users and nested groups from Microsoft Entra groups to CSV files.

When querying transitive members through Graph Explorer or local Graph PowerShell SDK, the default page size is limited to 100 objects. This script handles pagination automatically to retrieve all members.

## Features

- Exports all direct and transitive members including users and groups from a specified Microsoft Entra group
- Orders results by display name
- Handles pagination for large groups (Graph API default limit is 100 objects per page)
- Exports results to CSV files with detailed member information

## Prerequisites

- PowerShell 5.1 or higher
- Microsoft.Graph PowerShell module
- Appropriate Microsoft Graph API permissions:
  - GroupMember.Read.All
  - Directory.Read.All
  - Group.Read.All
  - Group.ReadWrite.All
  - GroupMember.ReadWrite.All

## Usage

1. Update the `$groupId` variable with your target group ID
2. Run the script

The exported files will be created in the current PowerShell working directory, not the script location.

### Query Specific Users

To search for specific users, you can use Graph Explorer with a search query:

```
https://graph.microsoft.com/v1.0/groups/{group-id}/transitiveMembers/microsoft.graph.user?$count=true&$orderby=displayName&$search="userPrincipalName:user@domain.com"
```

## Output Files

- `group_members.csv`: Contains all user member information
- `nested_groups.csv`: Contains all nested group information
- `group_members_raw.json`: Raw API response data

## References

- [List group transitive members](https://learn.microsoft.com/en-us/graph/api/group-list-transitivemembers)
- [Paging Microsoft Graph data in your app](https://learn.microsoft.com/en-us/graph/paging)
