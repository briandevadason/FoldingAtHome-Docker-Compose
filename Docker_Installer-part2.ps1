set-executionpolicy -scope CurrentUser -executionPolicy Bypass -Force
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  # Relaunch as an elevated process:
  Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
}

"Installing Ubuntu 20.04"
wsl --install -d Ubuntu-20.04

$wshell = New-Object -ComObject wscript.shell;
Start-Sleep -s 30

#Download and Install WSL2
"Downloading WSL2 update"
Invoke-WebRequest -Uri "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi" -Outfile wsl_update_x64.msi
"Installing wsl"
.\wsl_update_x64.msi

Start-Sleep -s 10
$wshell.SendKeys('{ENTER}')
Start-Sleep -s 10
$wshell.SendKeys('{ENTER}')

"Please Wait"
Start-Sleep -s 30
"Setting WSL 2 as your default version"
wsl --set-version Ubuntu-20.04 2
wsl -l -v
wsl --set-default-version 2
wsl -l -v
wsl --set-default Ubuntu-20.04 2
wsl -l -v
Start-Sleep -s 30




#Docker installation
"Downloading Docker"
Invoke-WebRequest -Uri "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe" -Outfile DockerDesktopInstaller.exe
"Installing Docker"
.\"DockerDesktopInstaller.exe" install --quiet

Unregister-ScheduledTask -TaskName "Docker_Installer_P2" -Confirm:$false

$Action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument C:\Users\Public\Downloads\FAH_Setup.ps1
$Trigger = New-ScheduledTaskTrigger -AtLogon
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "FAH_Builder" -Description "FoldingAtHome Docker Image Builder"

shutdown.exe /r /t 120

