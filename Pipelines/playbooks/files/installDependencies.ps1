Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-PackageProvider -Name NuGet -Force 
Install-Module -Name PowershellGet -Force
Install-Module -Name AksHci -Repository PSGallery -AcceptLicense -Force