##### Disable SMS Sign-in options for users in upn_list.txt

#### Import module
Import-Module Microsoft.Graph.Users.Actions

Connect-MgGraph -Scopes "User.Read.All", "Group.ReadWrite.All", "UserAuthenticationMethod.Read.All","UserAuthenticationMethod.ReadWrite","UserAuthenticationMethod.ReadWrite.All"

##### The value for phoneAuthenticationMethodId is 3179e48a-750b-4051-897c-87b9720928f7
$phoneAuthenticationMethodId = "3179e48a-750b-4051-897c-87b9720928f7"

#### Get the User Details from list
$upnList = Get-Content -Path "C:\upn_list.txt"

foreach ($upn in $upnList) {
    Write-Host "Processing user: $upn" -ForegroundColor Cyan
    $user = Get-MgUser -Filter "userPrincipalName eq '$upn'"
    
    if ($null -eq $user) {
        Write-Host "User not found: $upn" -ForegroundColor Red
        continue
    }

    #### validate the value for SmsSignInState
    $smssignin = Get-MgUserAuthenticationPhoneMethod -UserId $user.Id

    if($smssignin.SmsSignInState -eq "ready"){   
        #### Disable Sms Sign-In for the user is set to ready
        Disable-MgUserAuthenticationPhoneMethodSmsSignIn -UserId $user.Id -PhoneAuthenticationMethodId $phoneAuthenticationMethodId
        Write-Host "SMS sign-in disabled for user: $upn" -ForegroundColor Green
    }
    else {
        Write-Host "SMS sign-in status not set or found for user: $upn" -ForegroundColor Yellow
    }
}

Write-Host "Script completed." -ForegroundColor Green
##### End the script
