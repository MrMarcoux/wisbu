<#
 .Synopsis
  Utility to back up Windows 10 setup details into a zip file.

 .Description
  This utility backs up various recurring settings found in windows 10, 
  such as the start menu shortcuts and the environment variable, 
  all into a zip file.

 .Parameter Path
  Path to which to save the backup to.

 .Parameter Include
  Set of elements to include, from [startmenu, environment]. Defaults to startup.

 .Example
   # Backup-Util C:\Backup @("startmenu",  "environment")
#>
function Backup-Util {
    param(
        [string] $path,
        [string[]] $includes
    )
    
    if ((Test-Path $path) -OR (Test-Path "$path.zip")) {
        Write-Host "Backup file/folder already exists. Cannot overwrite it."
        return $False
    }

    if ($path -like '*.zip') {
        $path = $path.Trim(".zip")
    }
    
    New-Item -Path $path -ItemType Directory

    if ($includes.Contains("startmenu") -OR $includes.length -eq 0) {
        Backup-StartMenuData $path
    }

    if($includes.Contains("environment")) {
        Backup-EnvrironmentData $path
    }

    Add-Type -assembly "system.io.compression.filesystem"
    [io.compression.zipfile]::CreateFromDirectory($path, "$path.zip")
    Write-Host "New backup created at $path.zip"
    Remove-Item $path -Recurse

    return $True
}

function Backup-StartMenuData {
    param(
        [string] $path
    )

    $subpath = "$path\start menu"
    Copy-Item "C:\ProgramData\Microsoft\Windows\Start Menu" -Destination "$subpath\global" -Recurse -exclude @("*.ini","*Panel.lnk")
    Copy-Item "$env:APPDATA\Microsoft\Windows\Start Menu" -Destination "$subpath\local" -Recurse -exclude @("*.ini","*Panel.lnk")

    Write-Host "Startup menu data successfully copied."
}

function Backup-EnvrironmentData {
    param(
        [string] $path
    )

    $subpath = "$path\environment\"
    New-Item -Path $subpath -ItemType Directory
    [Environment]::GetEnvironmentVariables() | Format-Table -wrap -autosize | Out-File -FilePath "$subpath\variables.txt"
    Write-Host "Environment variables sucessfully logged."
}

Export-ModuleMember -Function Backup-Util