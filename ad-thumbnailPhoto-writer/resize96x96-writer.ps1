function Set-UserThumbnailPhoto {
    param(
        [string]$ImagePath,
        [string]$UserPrincipalName,
        [int]$Size = 96
    )
    
    # Import System.Drawing assembly for image processing
    Add-Type -AssemblyName System.Drawing
    
    try {
        # Validate if the image file exists
        if (-not (Test-Path $ImagePath)) {
            throw "Image file not found: $ImagePath"
        }
        
        # Verify user exists using UserPrincipalName
        $adUser = Get-ADUser -Filter "UserPrincipalName -eq '$UserPrincipalName'"
        
        if (-not $adUser) {
            throw "AD user not found: $UserPrincipalName"
        }
        
        Write-Host "User found: $($adUser.DistinguishedName)" -ForegroundColor Green
        
        # Read and process the image
        $originalImage = [System.Drawing.Image]::FromFile($ImagePath)
        $thumbnail = New-Object System.Drawing.Bitmap($Size, $Size)
        $graphics = [System.Drawing.Graphics]::FromImage($thumbnail)
        
        # Configure image quality settings
        $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
        
        # Draw the resized image
        $graphics.DrawImage($originalImage, 0, 0, $Size, $Size)
        
        # Save to memory stream
        $memoryStream = New-Object System.IO.MemoryStream
        $thumbnail.Save($memoryStream, [System.Drawing.Imaging.ImageFormat]::Jpeg)
        
        # Update AD user's thumbnail photo
        Set-ADUser -Identity $adUser -Replace @{thumbnailPhoto=$memoryStream.ToArray()}
        
        Write-Host "Successfully updated user thumbnail photo" -ForegroundColor Green
    }
    catch {
        Write-Error "An error occurred: $_"
    }
    finally {
        # Clean up resources
        if ($graphics) { $graphics.Dispose() }
        if ($thumbnail) { $thumbnail.Dispose() }
        if ($originalImage) { $originalImage.Dispose() }
        if ($memoryStream) { $memoryStream.Dispose() }
    }
}

# Example usage with UserPrincipalName
Set-UserThumbnailPhoto -ImagePath "C:\Users\ray\Desktop\google.jpg" -UserPrincipalName "user@domain.com"
