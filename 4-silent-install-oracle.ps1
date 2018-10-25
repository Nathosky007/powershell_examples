<#Author: Sainath M
 Date: 17062018
 Name: 4-silent-install-oracle.ps1
 Purpose: Silently install required components from Oracle Universal Installer [OUI]
 License: MIT License
#>

$Logfile=<log file location>

Function OracleComponentInstall
{
    [CmdletBinding()]
    param(

        [Parameter(Mandatory=$false)]
        [Alias("L")]
        [string]
        $Logfile
    )

    $ErrorActionPreference = "Stop"

    UnzipArchive "C:\installs\Utilities\ODAC1110720.zip" "C:\installs\Utilities"  > $Logfile

    $OracleRegPath="HKLM:\SOFTWARE\Oracle\"

    md $OracleRegPath -ErrorAction silentlycontinue
    echo "Registry path created for Oracle" >> $Logfile

    Set-ItemProperty -Path $OracleRegPath -Name "inst_loc" -Value "C:\cfn\log\Oracle"
    echo "Registry path set for Inventory" >> $Logfile

    Start-Process -FilePath "C:\installs\Utilities\ODAC1110720\setup.exe" -ArgumentList "-noConsole -silent -debug -force -nowait FROM_LOCATION=C:\installs\Utilities\ODAC1110720\stage\custom_installation_app1.xml ORACLE_HOME=H:\Oracle\product\11.1.0\client_1 ORACLE_HOME_NAME=OracleClient_11Home ORACLE_BASE=H:\Oracle"

    echo "Oracle Data provider for .NET Help and Oracle Provider for ASP.NET Help completed "  >> $Logfile
}
