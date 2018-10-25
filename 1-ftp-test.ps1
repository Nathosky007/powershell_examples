<#Author: Sainath M
 Date: 17062018
 Name: 1-ftp-test.ps1
 Purpose: This program is used to upload a sample file to a FTP server
 License: MIT License
 Modules Used: PSFTP [https://gallery.technet.microsoft.com/scriptcenter/PowerShell-FTP-Client-db6fe0cb]
#>

Import-Module PSFTP

#Setup a FTP config session in local machine
$FtpServer = "ftp://127.168.12.12"
$FtpUsername = "Admin01"
$FtpPassword = "password"

#Encrypt the password
$FTPSecurePassword = ConvertTo-SecureString -String $FTPPassword -asPlainText -Force
$FTPCredential = New-Object System.Management.Automation.PSCredential($FTPUsername,$FTPSecurePassword)

$localPath = "<path to a sample file on local system>"
#setup FTP configuration with server, credentials
Set-FTPConnection -Credentials $FTPCredential  -Server $FtpServer -Session MySession2 -UsePassive -KeepAlive -Verbose

#Instantiate FTP connection using configured session
$Session = Get-FTPConnection -Session MySession2

# $path= adjustments

Get-FTPChildItem -Session $Session -Path  adjustments -Recurse

Add-FTPItem -Path adjustments -LocalPath $localPath -Session $Session -Verbose
