<#Author: Sainath M
 Date: 17062018
 Name: 6-Jakara-ISAPI-config-v0.ps1
 Purpose: Install and configure Jakarta ISAPI redirection in IIS [Win 2008 R2]
 Source: https://jhmeier.com/2009/10/16/acitvating-the-isapi-redirect-for-tomcat-under-iis-7-5-w2k8-r2-64-bit/
 License: MIT License
#>



$Logfile=<log file location>

Function UnlockIISAnonymousAuthenticationConfig {
    #override default flag to configure sub-sections in IIS config
    $webAdminAssembly = [System.Reflection.Assembly]::LoadFrom("$env:systemroot\system32\inetsrv\Microsoft.Web.Administration.dll")

    $mgr = New-Object Microsoft.Web.Administration.ServerManager
    # load appHost config
    $conf = $mgr.GetApplicationHostConfiguration()

    # unlock all sections in system.webServer
    $appPoolIdentityAnonAuthBefore=$conf.GetSection("system.webServer/security/authentication/anonymousAuthentication").OverrideMode
    echo "IIS config flag for anonymous auth: $($appPoolIdentityAnonAuthBefore)" > $Logfile

    $conf.GetSection("system.webServer/security/authentication/anonymousAuthentication").OverrideMode="Allow"
    $mgr.CommitChanges()

    $appPoolIdentityAnonAuthAfter=$conf.GetSection("system.webServer/security/authentication/anonymousAuthentication").OverrideMode
    echo "IIS config flag for anonymous auth after: $($appPoolIdentityAnonAuthAfter)" >> $Logfile

}

Function JakartaISAPIConfig  {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [Alias("L")]
        [string]
        $Logfile
    )
    #Jakarta ISAPI configuration
    Copy-Item "C:\installs\Utilities\tomcat-connectors-1.2.43-windows-i386-iis\isapi_redirect.dll" -Destination "H:\Jakarta Isapi\bin\"

    echo "Jakarta ISAPI config started" >> $Logfile

    #Registry settings for Jakarta ISAPI
    mkdir "HKLM:\SOFTWARE\Wow6432Node\Apache` Software` Foundation" -ErrorAction SilentlyContinue
    mkdir "HKLM:\SOFTWARE\Wow6432Node\Apache` Software` Foundation\Jakarta` Isapi` Redirector" -ErrorAction SilentlyContinue
    mkdir "HKLM:\SOFTWARE\Wow6432Node\Apache` Software` Foundation\Jakarta` Isapi` Redirector\1.0" -ErrorAction SilentlyContinue

    $JakartaISAPIRegPath="HKLM:\SOFTWARE\Wow6432Node\Apache` Software` Foundation\Jakarta` Isapi` Redirector\1.0"

    Set-ItemProperty -Path $JakartaISAPIRegPath -Name "extension_uri" -Value "/jakarta/isapi_redirect.dll"
    Set-ItemProperty -Path $JakartaISAPIRegPath -Name "log_file" -Value "H:\Jakarta Isapi\logs\isapi.log"
    Set-ItemProperty -Path $JakartaISAPIRegPath -Name "log_level" -Value "info"
    Set-ItemProperty -Path $JakartaISAPIRegPath -Name "worker_file" -Value "H:\\Jakarta Isapi\\conf\\workers.properties"
    Set-ItemProperty -Path $JakartaISAPIRegPath -Name "worker_mount_file" -Value "H:\\Jakarta Isapi\\conf\\uriworkermap.properties"
    Set-ItemProperty "H:\WebSite1\Web.config" -Name IsReadOnly -Value $false

    UnlockIISAnonymousAuthenticationConfig

    Add-WebConfiguration -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/security/isapiCgiRestriction" -value @{description='isapi_redirect.dll';path='H:\Jakarta Isapi\bin\isapi_redirect.dll';allowed='True'}
    echo "Added ISAPI Restriction" >> $Logfile

    Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -name "notListedIsapisAllowed" -filter "system.webServer/security/isapiCgiRestriction" -value 'True'
    echo "Enabled flag to allow unspecified APIs" >> $Logfile

    Add-WebConfiguration -pspath 'MACHINE/WEBROOT/APPHOST' -filter "system.webServer/isapiFilters" -value @{name='isapi_redirect';path='H:\Jakarta Isapi\bin\isapi_redirect.dll';enableCache='True';preCondition='bitness32'}
    echo "Add Jakarta ISAPI to filter" >> $Logfile

    New-WebVirtualDirectory -Site "Default Web Site/WebSite1" -Name "jakarta" -PhysicalPath "H:\Jakarta Isapi\bin\"
    echo "Created virtual directory under WebSite1" >> $Logfile

    Set-WebConfigurationProperty -Filter "/system.webServer/security/authentication/anonymousAuthentication" -PSPath "IIS:\Sites\Default Web Site"   -Name username -Value ""
    echo "Add anonymousAuthentication to App pool" >> $Logfile

    Set-WebConfiguration -filter "system.webServer/handlers/@AccessPolicy" -pspath "IIS:\Sites\Default Web Site" -value "Read, Script, Execute"
    echo "Add execute permission to Handler mappings" >> $Logfile

    echo "Jakarta ISAPI config completed" >> $Logfile

}

JakartaISAPIConfig -L $Logfile
