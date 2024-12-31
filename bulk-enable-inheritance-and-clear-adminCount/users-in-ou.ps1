Import-Module ActiveDirectory

# Get users from the specified OU
$usersOU = Get-ADUser -Filter * -SearchBase "OU=YourOU,DC=YourDomain,DC=com"

# Update adminCount and enable inheritance
foreach ($user in $usersOU) {
   # Set adminCount to 0
   Set-ADUser $user -Clear adminCount

   # Enable inheritance
   $acl = Get-ACL -Path "AD:$($user.DistinguishedName)"
   $acl.SetAccessRuleProtection($false, $true)
   Set-ACL -Path "AD:$($user.DistinguishedName)" -AclObject $acl
}
