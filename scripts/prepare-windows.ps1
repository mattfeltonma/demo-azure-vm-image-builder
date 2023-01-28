# Setup logging
Start-Transcript -path "C:\MachinePrep\logs\log.txt"

# Create directory to store installation files
New-Item -ItemType directory -Path C:\MachinePrep\files

try {

    # Install nuget package manager
    Write-Host "Installing nuget..."
    Install-PackageProvider -Name Nuget -Force 

    # Install Azure CLI
    Write-Host "Downloading Azure CLI..."
    $uri = "https://aka.ms/installazurecliwindows"
    Invoke-WebRequest -Uri $uri -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi

    # Install Azure PowerShell
    Write-Host "Installing Azure CLI..."
    Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force
}
catch {
    Write-Host "Unable to install Azure CLI or PowerShell CLI"
}
try {

    # Download Google Chrome browser
    Write-Host "Downloading and installing Google Chrome..."
    $uri = "https://dl.google.com/chrome/install/chrome_installer.exe"
    $destination = "C:\MachinePrep\files\chrome_installer.exe"
    Invoke-WebRequest -Uri $uri -OutFile $destination

    # Install Google Chroome
    Start-Process -FilePath $destination -ArgumentList '/silent /install' -Wait
}
catch {
    Write-Host "Unable to install Google Chrome"
}
try {
    # Function to add path
    function Add-Path($Path) {
        $Path = [Environment]::GetEnvironmentVariable("PATH", "Machine") + [IO.Path]::PathSeparator + $Path
        [Environment]::SetEnvironmentVariable( "Path", $Path, "Machine" )
    }

    # Download Packer
    Write-Host "Installing Packer..."
    $uri = "https://releases.hashicorp.com/packer/1.8.5/packer_1.8.5_windows_amd64.zip"
    $destination = "C:\MachinePrep\files\packer.zip"
    Invoke-WebRequest -Uri $uri -OutFile $destination

    # Deploy Packer
    New-Item -Path 'C:\Packer' -ItemType Directory
    Expand-Archive "C:\MachinePrep\files\packer.zip" -DestinationPath "C:\Packer"
    Add-Path "C:\Packer"
}
catch {
    Write-Host "Unable to install Packer"
} 

Stop-Transcript 