# Import Active Directory module
Import-Module ActiveDirectory

# Set parameters
$userUPN = "user@domain.com"  # User's UPN
$photoPath = "C:\Users\user\Desktop\photo.png"  # Path to photo

try {
    # First get the user object
    $user = Get-ADUser -Filter "UserPrincipalName -eq '$userUPN'"

    if ($user) {
        # Verify photo file exists
        if (Test-Path $photoPath) {
            # Read photo file into byte array
            $photoBytes = [byte[]](Get-Content $photoPath -Encoding Byte)
            
            # Update user's thumbnail photo
            Set-ADUser -Identity $user.DistinguishedName -Replace @{thumbnailPhoto=$photoBytes}
            Write-Host "User photo has been successfully updated"
        } else {
            Write-Error "Photo file not found at path: $photoPath"
        }
    } else {
        Write-Error "User not found with UPN: $userUPN"
    }
} catch {
    Write-Error "An error occurred: $_"
}
