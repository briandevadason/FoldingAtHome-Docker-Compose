set-executionpolicy -scope CurrentUser -executionPolicy Bypass -Force
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
  # Relaunch as an elevated process:
  Start-Process powershell.exe "-File",('"{0}"' -f $MyInvocation.MyCommand.Path) -Verb RunAs
  exit
}

$wshell = New-Object -ComObject wscript.shell
Start-Sleep -s 120
$wshell.SendKeys('git clone https://github.com/linuxserver/docker-foldingathome.git'+'{ENTER}')
$wshell.SendKeys('cd docker-foldingathome'+ '{ENTER}')
$wshell.SendKeys('docker build --no-cache --pull -t lscr.io/linuxserver/foldingathome:latest .' + '{ENTER}')

#Running 2 Docker Containers with Docker Compose

#$wshell.SendKeys('mkdir dockerfiles' +'{ENTER}' )
#$wshell.SendKeys('cd ..' + '{ENTER}' )
#Start-Sleep -s 2
#$wshell.SendKeys('cp docker-compose.yml dockerfiles')
Start-Sleep -s 120
$wshell.SendKeys('cd ..' + '{ENTER}' )
$wshell.SendKeys('docker compose up -d --scale foldingathome=2' + '{ENTER}' )

#$wshell.SendKeys('docker-compose up -d --scale foldingathome=5' + '{ENTER}')

Unregister-ScheduledTask -TaskName "FAH_Builder" -Confirm:$false