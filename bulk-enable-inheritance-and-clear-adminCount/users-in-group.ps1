Import-Module ActiveDirectory

# Define the group name
$groupName = "YourGroupName"

# Get users from the specified group
$usersGroup = Get-ADGroupMember -Identity $groupName -Recursive | Where-Object { $_.objectClass -eq 'user' }

# Update adminCount and enable inheritance for each user
foreach ($user in $usersGroup) {
    # Set adminCount to 0
    Set-ADUser $user -Clear adminCount

    # Enable inheritance
    $acl = Get-ACL -Path "AD:$($user.DistinguishedName)"
    $acl.SetAccessRuleProtection($false, $true)
    Set-ACL -Path "AD:$($user.DistinguishedName)" -AclObject $acl
}
