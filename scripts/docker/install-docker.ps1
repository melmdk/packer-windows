Set-ExecutionPolicy Bypass -scope Process
New-Item -Type Directory -Path "$($env:ProgramFiles)\docker"
# wget -outfile $env:TEMP\docker-cs-1.12.zip "https://download.docker.com/components/engine/windows-server/cs-1.12/docker-1.12.2.zip"
wget -outfile $env:TEMP\docker-1.13.0.zip "https://get.docker.com/builds/Windows/x86_64/docker-1.13.0.zip"
Expand-Archive -Path $env:TEMP\docker-1.13.0.zip -DestinationPath $env:TEMP -Force
copy $env:TEMP\docker\*.exe $env:ProgramFiles\docker
Remove-Item $env:TEMP\docker-1.13.0.zip
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$($env:ProgramFiles)\docker", [EnvironmentVariableTarget]::Machine)
$env:Path = $env:Path + ";$($env:ProgramFiles)\docker"
. dockerd --register-service -H npipe:// -H 0.0.0.0:2375 -G docker

Write-Host "Fix --restart=always for reboot ..."
# see https://github.com/docker/docker/issues/27544
& sc.exe config Docker depend= LanmanWorkstation

Start-Service Docker

Write-Host "Installing WindowsServerCore container image..."
& "C:\Program Files\docker\docker.exe" pull microsoft/windowsservercore

Write-Host "Installing NanoServer container image..."
& "C:\Program Files\docker\docker.exe" pull microsoft/nanoserver
