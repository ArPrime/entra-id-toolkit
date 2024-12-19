# Import Active Directory module
Import-Module ActiveDirectory

# Set parameters
# Option 1: Using UPN
$userIdentity = "user@domain.com"  # Replace with actual user's UPN
# Option 2: Using DN
# $userIdentity = "CN=,OU=,DC="

# Specify the path to the photo file
$photoPath = "C:\Users\ray\Desktop\google.jpg"  # Replace with actual photo path

# Read the image file into a byte array
# The -Encoding Byte parameter ensures proper binary file reading
$photoBytes = [byte[]](Get-Content $photoPath -Encoding Byte)

# Update the user's thumbnailPhoto attribute
Set-ADUser -Identity $userIdentity -Replace @{thumbnailPhoto=$photoBytes}

Write-Host "User photo has been successfully updated"
