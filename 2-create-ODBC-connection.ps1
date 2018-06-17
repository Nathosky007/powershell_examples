<#Author: Sainath M
 Date: 17062018
 Name: 2-create-ODBC-connection.ps1
 Purpose: Sets up System DSN for  32-bit and 64-bit ODBC application in Win 2008 R2
 License: MIT License
#>

$intLndODBCDataSourceList=@("DevReports","LndDbMain")
$intPsvODBCDataSourceList="DevReportsPsv"

$prodLndODBCDataSourceList=@("ProdReports","TestReports","LndDbMain")
$prodPsvODBCDataSourceList=@("ProdReportsPsv","TestReportsPsv")

$uatLndODBCDataSourceList=@("TestReports","LndDbMain")
$uatPsvODBCDataSourceList="TestReportsPsv"

$lndDBName="database1"
$psvDBName="database2"

$driver="SQL Server"
$DBUserName="reports"

Function CreateODBCDataSourcesConfig
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $DSNName,

        [Parameter(Mandatory=$true)]
        [string]
        $DBName,

        [Parameter(Mandatory=$true)]
        [string]
        $ServerName,

        [Parameter(Mandatory=$true)]
        [string]
        $DBUserName,

        [Parameter(Mandatory=$true)]
        [string]
        $connectionDriver,

        [Parameter(Mandatory=$false)]
        [Alias("L")]
        [string]
        $Logfile
    )

        $ErrorActionPreference = "Stop"

        #Array of registry paths for 32-bit and 64-bit ODBC installations
        $ODBCPaths=@(@("HKLM:\SOFTWARE\Wow6432Node\ODBC\ODBC.INI\$($DSNName)",
        "HKLM:\SOFTWARE\Wow6432Node\ODBC\ODBC.INI\ODBC Data Sources",
        "HKLM:\SOFTWARE\Wow6432Node\ODBC\ODBCINST.INI\$($connectionDriver)"),
        @("HKLM:\SOFTWARE\ODBC\ODBC.INI\$($DSNName)",
        "HKLM:\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources",
        "HKLM:\SOFTWARE\ODBC\ODBCINST.INI\$($connectionDriver)"))

        LogInfo "Creating ODBC connection for: $($DSNName) " $Logfile
        LogInfo "Database name : $($DBName)" $Logfile
        LogInfo "Database Server name : $($ServerName)" $Logfile
        LogInfo "Database User name : $($DBUserName)" $Logfile
        LogInfo "Connection Driver : $($connectionDriver) " $Logfile

    foreach ($regPath in $ODBCPaths)
    {
        foreach ($regODBCINIPath in $regPath[0])
        {
            md $regODBCINIPath -ErrorAction silentlycontinue

            Set-ItemProperty -path $regODBCINIPath -name Description -value $DSNName
            Set-ItemProperty -path $regODBCINIPath -name Server -value $ServerName
            Set-ItemProperty -path $regODBCINIPath -name Database -value $DBName
            Set-ItemProperty -path $regODBCINIPath -name LastUser -value $DBUserName
   }

      foreach ($regODBCDSPath in $regPath[1])
   {
        md $regODBCDSPath -ErrorAction silentlycontinue

        Set-ItemProperty -path $regODBCDSPath -name $DSNName -value $connectionDriver
   }

      foreach ($regODBCDriverPath in $regPath[2])
        {
            Set-ItemProperty -path $regODBCDriverPath -name Driver -value (Get-ItemProperty $($regPath[2])).Driver
        }
    }

}

Function CreateODBCDataSources
  {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]
        $Environment

    )

  if ($Environment -eq "int")
  {

        CreateODBCDataSourcesConfig -DSNName $intLndODBCDataSourceList[0] -DBName $lndDBName -ServerName $LNDDBDNSName -DBUserName $DBUserName -connectionDriver $driver -L $Logfile

        CreateODBCDataSourcesConfig -DSNName $intLndODBCDataSourceList[1] -DBName $lndDBName -ServerName $LNDDBDNSName -DBUserName $DBUserName  -connectionDriver $driver   -L $Logfile

        CreateODBCDataSourcesConfig -DSNName $intPsvODBCDataSourceList -DBName $psvDBName -ServerName $PSVDBDNSName -DBUserName $DBUserName -connectionDriver $driver -L $Logfile


  }
  elseif ($Environment -eq "uat")
  {

        CreateODBCDataSourcesConfig -DSNName $uatLndODBCDataSourceList[0] -DBName $lndDBName -ServerName $LNDDBDNSName -DBUserName $DBUserName  -connectionDriver $driver -L $Logfile
        CreateODBCDataSourcesConfig -DSNName $intLndODBCDataSourceList[1] -DBName $lndDBName -ServerName $LNDDBDNSName -DBUserName $DBUserName  -connectionDriver $driver  -L $Logfile

        CreateODBCDataSourcesConfig -DSNName $uatPsvODBCDataSourceList -DBName $psvDBName -ServerName $PSVDBDNSName -DBUserName $DBUserName  -connectionDriver $driver -L $Logfile


  }

  elseif ($Environment -eq "prod")
  {

        CreateODBCDataSourcesConfig -DSNName $prodLndODBCDataSourceList[0] -DBName $lndDBName -ServerName $LNDDBDNSName -DBUserName $DBUserName  -connectionDriver $driver -L $Logfile
        CreateODBCDataSourcesConfig -DSNName $prodLndODBCDataSourceList[1] -DBName $lndDBName -ServerName $LNDDBDNSName -DBUserName $DBUserName  -connectionDriver $driver -L $Logfile
        CreateODBCDataSourcesConfig -DSNName $prodLndODBCDataSourceList[2] -DBName $lndDBName -ServerName $LNDDBDNSName -DBUserName $DBUserName  -connectionDriver $driver  -L $Logfile


        CreateODBCDataSourcesConfig -DSNName $prodPsvODBCDataSourceList[0] -DBName $psvDBName -ServerName $PSVDBDNSName -DBUserName $DBUserName  -connectionDriver $driver -L $Logfile
        CreateODBCDataSourcesConfig -DSNName $prodPsvODBCDataSourceList[1] -DBName $psvDBName -ServerName $PSVDBDNSName -DBUserName $DBUserName  -connectionDriver $driver -L $Logfile

      }

  else {
    LogInfo -Logstring "Not a valid environment" -Logfile $Logfile
  }
 }
