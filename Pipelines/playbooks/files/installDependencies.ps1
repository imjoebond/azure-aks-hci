Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-PackageProvider -Name NuGet -Force -Confirm:$false
Install-Module -Name PowershellGet -Force -Confirm:$false
Install-Module -Name AksHci -Repository PSGallery -AcceptLicense -Force -Confirm:$false