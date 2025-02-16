# Ensure Microsoft.Graph module is installed and connected
Import-Module Microsoft.Graph.Groups

# Connect to Graph API (if not already connected)
Connect-MgGraph -Scopes "GroupMember.Read.All", "Directory.Read.All", "Group.Read.All", "Group.ReadWrite.All", "GroupMember.ReadWrite.All"

# Set the group ID to query
$groupId = "YOUR GROUP ID"

# Initialize results arrays
$allMembers = @()
$nestedGroups = @()

# Set initial query with ordering by displayName and count parameter
$query = "https://graph.microsoft.com/v1.0/groups/$groupId/transitiveMembers?`$orderby=displayName&`$count=true"

# Define headers including ConsistencyLevel
$headers = @{
    'ConsistencyLevel' = 'eventual'
}

# Loop to get data from all pages
do {
    try {
        # Direct API call using REST method with headers
        $response = Invoke-MgGraphRequest -Method GET -Uri $query -Headers $headers
        
        # Separate users and groups from the results
        foreach ($member in $response.value) {
            if ($member.'@odata.type' -eq '#microsoft.graph.group') {
                $nestedGroups += $member
            } else {
                $allMembers += $member
            }
        }
        
        # Get next page link
        $query = $response.'@odata.nextLink'
        
        # Show progress
        Write-Host "Retrieved $($allMembers.Count) members and $($nestedGroups.Count) nested groups..."
        
        # Optional: Add delay to avoid throttling
        Start-Sleep -Milliseconds 100
        
    } catch {
        Write-Error "Error retrieving data: $_"
        break
    }
} while ($query)

# Export members to CSV
$allMembers | Select-Object @{Name='Type';Expression={$_.'@odata.type'}},
    @{Name='ID';Expression={$_.id}},
    @{Name='DisplayName';Expression={$_.displayName}},
    @{Name='GivenName';Expression={$_.givenName}},
    @{Name='Surname';Expression={$_.surname}},
    @{Name='UserPrincipalName';Expression={$_.userPrincipalName}},
    @{Name='Mail';Expression={$_.mail}},
    @{Name='JobTitle';Expression={$_.jobTitle}},
    @{Name='BusinessPhones';Expression={$_.businessPhones -join ';'}},
    @{Name='MobilePhone';Expression={$_.mobilePhone}},
    @{Name='OfficeLocation';Expression={$_.officeLocation}},
    @{Name='PreferredLanguage';Expression={$_.preferredLanguage}} |
    Export-Csv -Path "group_members.csv" -NoTypeInformation -Encoding UTF8

# Export nested groups to separate CSV
$nestedGroups | Select-Object @{Name='Type';Expression={$_.'@odata.type'}},
    @{Name='ID';Expression={$_.id}},
    @{Name='DisplayName';Expression={$_.displayName}},
    @{Name='Description';Expression={$_.description}},
    @{Name='Mail';Expression={$_.mail}},
    @{Name='MailEnabled';Expression={$_.mailEnabled}},
    @{Name='MailNickname';Expression={$_.mailNickname}},
    @{Name='SecurityEnabled';Expression={$_.securityEnabled}},
    @{Name='CreatedDateTime';Expression={$_.createdDateTime}},
    @{Name='RenewedDateTime';Expression={$_.renewedDateTime}},
    # On-premises sync related properties
    @{Name='OnPremisesSyncEnabled';Expression={$_.onPremisesSyncEnabled}},
    @{Name='OnPremisesDomainName';Expression={$_.onPremisesDomainName}},
    @{Name='OnPremisesNetBiosName';Expression={$_.onPremisesNetBiosName}},
    @{Name='OnPremisesSamAccountName';Expression={$_.onPremisesSamAccountName}},
    @{Name='OnPremisesSecurityIdentifier';Expression={$_.onPremisesSecurityIdentifier}},
    @{Name='OnPremisesLastSyncDateTime';Expression={$_.onPremisesLastSyncDateTime}},
    # Additional properties
    @{Name='SecurityIdentifier';Expression={$_.securityIdentifier}},
    @{Name='Visibility';Expression={$_.visibility}},
    @{Name='Classification';Expression={$_.classification}},
    # Array properties joined as strings
    @{Name='GroupTypes';Expression={$_.groupTypes -join ';'}},
    @{Name='ProxyAddresses';Expression={$_.proxyAddresses -join ';'}},
    @{Name='CreationOptions';Expression={$_.creationOptions -join ';'}} |
    Export-Csv -Path "nested_groups.csv" -NoTypeInformation -Encoding UTF8

# Export raw API response to JSON
$response | ConvertTo-Json -Depth 10 | Out-File "group_members_raw.json"

Write-Host "Complete! Exported $($allMembers.Count) members and $($nestedGroups.Count) nested groups"
Write-Host "Data saved to group_members.csv, nested_groups.csv, and group_members_raw.json"
