set-executionpolicy -scope CurrentUser -executionPolicy Bypass -Force
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  # Relaunch as an elevated process:
  Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
}

# STEP 1: Enable Virtual Machine Platform feature
"Enabling Virtual Machine Platform feature"
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# STEP 2: Enable WSL feature
"Enabling WSL feature"
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

cd $home\downloads\FAHInstallerScripts

Copy-Item Docker_Installer-part2.ps1 -Destination "C:\Users\Public\Downloads"
Copy-Item FAH_Setup.ps1 -Destination "C:\Users\Public\Downloads"
Copy-Item .wslconfig -Destination $home\

$Action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument C:\Users\Public\Downloads\Docker_Installer-part2.ps1
$Trigger = New-ScheduledTaskTrigger -AtLogon
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "Docker_Installer_P2" -Description "Docker Installer Part 2"

shutdown.exe /r /t 10