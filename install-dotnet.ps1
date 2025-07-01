# Variables
$dotnetVersion = "8.0.301"
$downloadUrl = "https://dotnetcli.azureedge.net/dotnet/Sdk/$dotnetVersion/dotnet-sdk-$dotnetVersion-win-x64.zip"
$tempFolder = "C:\dotnet-temp"
$installFolder = "C:\Program Files\dotnet"
$zipPath = "$tempFolder\dotnet-sdk.zip"

if (!(Test-Path $tempFolder)) {
    New-Item -ItemType Directory -Path $tempFolder
}

if (!(Test-Path $installFolder)) {
    New-Item -ItemType Directory -Path $installFolder
}

Write-Output "Downloading .NET SDK $dotnetVersion..."

Add-Type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@

#Check this for PROD
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy 

Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath

Write-Output "Extracting SDK..."
Expand-Archive -Path $zipPath -DestinationPath $installFolder -Force

Remove-Item -Path $zipPath -Force

Write-Output "Install complete."

#Check installation
$env:PATH = "$installFolder;$env:PATH"
dotnet --version
