# Import required modules
Import-Module ActiveDirectory
Import-Module Microsoft.Graph.Authentication

# Connect to Microsoft Graph with required permissions
Connect-MgGraph -Scope @(
    "Device.ReadWrite.All",
    "Directory.ReadWrite.All", 
    "Directory.AccessAsUser.All",
    "DeviceManagementConfiguration.ReadWrite.All", 
    "DeviceManagementManagedDevices.ReadWrite.All"
)

# Configure Graph API endpoint (Beta or v1.0)
$graphEndpoint = "https://graph.microsoft.com/beta" # Change to v1.0 if needed

# Setup logging
$logPath = "$env:USERPROFILE\Desktop\DeviceSync.log"
function Write-Log {
    param ([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $Message"
    Write-Host $logEntry
    Add-Content -Path $logPath -Value $logEntry
}

# Retrieve all devices from Azure AD with pagination
function Get-AllAADDevices {
    $devices = @()
    $apiEndpoint = "$graphEndpoint/devices"
    $pageCount = 1
    
    do {
        try {
            $response = Invoke-MgGraphRequest -Method GET -Uri $apiEndpoint
            $devices += $response.value
            $apiEndpoint = $response.'@odata.nextLink'
            Write-Log "Retrieved page $pageCount of devices (${$response.value.Count} devices)"
            $pageCount++
        }
        catch {
            Write-Log "Error retrieving devices: $_"
            break
        }
    } while ($null -ne $apiEndpoint)
    
    Write-Log "Total devices retrieved: $($devices.Count)"
    return $devices
}

# Backup the retrieved data to a file
function Backup-DataToJson {
    param (
        [Parameter(Mandatory=$true)]
        [array]$Data,
        
        [Parameter(Mandatory=$true)]
        [string]$FilePath
    )
    
    try {
        $Data | ConvertTo-Json -Depth 4 | Set-Content -Path $FilePath -Force
        Write-Log "Data backed up to $FilePath"
    }
    catch {
        Write-Log "Failed to backup data: $_"
    }
}

# Main script execution
Write-Log "Script started"

# Get all devices from Azure AD
$allDevices = Get-AllAADDevices

# Backup devices data
$backupPath = "$env:USERPROFILE\Desktop\devices.json"
Backup-DataToJson -Data $allDevices -FilePath $backupPath

# Define custom AD properties to retrieve
$customProperties = @(
    "extensionAttribute15",
    "msDS-cloudExtensionAttribute14",
    "objectGuid"
)

# Process each device
$syncCount = 0
$errorCount = 0

foreach ($device in $allDevices) {
    $deviceName = $device.displayName
    $cloudId = $device.id
    $localGuid = $device.deviceId
    
    Write-Log "Processing device: $deviceName"
    
    # Skip pure cloud devices (no local deviceId)
    if ([string]::IsNullOrEmpty($localGuid)) {
        Write-Log "Skipping pure cloud device: $deviceName"
        continue
    }
    
    # Find corresponding local AD device
    try {
        $localDevice = Get-ADObject -Filter "ObjectGUID -eq '$localGuid'" -Properties $customProperties -ErrorAction Stop
        
        if ($null -eq $localDevice) {
            Write-Log "No matching local AD device found for: $deviceName ($localGuid)"
            continue
        }
        
        # Prepare update payload
        $updateBody = @{
            extensionAttributes = @{
                extensionAttribute15 = $localDevice.extensionAttribute15
                extensionAttribute14 = $localDevice.'msDS-cloudExtensionAttribute14'
            }
        }
        
        # Update Azure AD device attributes
        Invoke-MgGraphRequest -Method PATCH -Uri "$graphEndpoint/devices/$cloudId" -Body ($updateBody | ConvertTo-Json) -ErrorAction Stop
        Write-Log "Successfully updated attributes for: $deviceName"
        $syncCount++
    }
    catch {
        Write-Log "Error processing device $deviceName ($localGuid): $_"
        $errorCount++
    }
}

# Output summary
Write-Log "Script completed. Devices processed: $($allDevices.Count), Updated: $syncCount, Errors: $errorCount"