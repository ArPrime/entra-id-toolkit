# Import Active Directory module
Import-Module ActiveDirectory

# Define Organizational Unit (OU) path
$ouPath = "OU=Users,DC=domain,DC=com"

# Define basic user information
$domain = "domain.com"
$password = "YourSecure2025!"
$userPrefix = "BulkCreateUser"

# Create 3 users
for ($i = 1; $i -le 3; $i++) {
    $username = $userPrefix + $i
    $userPrincipalName = $username + "@" + $domain
    $displayName = $userPrefix + $i
    $givenName = $i
    $surname = $userPrefix

    # Create user
    New-ADUser -SamAccountName $username `
        -UserPrincipalName $userPrincipalName `
        -Name $username `
        -GivenName $givenName `
        -Surname $surname `
        -DisplayName $displayName `
        -Path $ouPath `
        -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) `
        -Enabled $true

    # Output created username
    Write-Host "Created user: $username"
}

Write-Host "Finished creating 3 users."
