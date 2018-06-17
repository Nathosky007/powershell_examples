<#Author: Sainath M
 Date: 17062018
 Name: 2-create-ODBC-connection.ps1
 Purpose: Sets up System DSN for  32-bit and 64-bit ODBC application in Win 2008 R2
 License: MIT License
#>

$intODBCDataSourceList=@("int1","int2")
$prodODBCDataSourceList=@("prod1","prod2")
$uatODBCDataSourceList=@("uat1","uat2")

$DBName="database1"

$driver="SQL Server"
$DBUserName="reports"

$Logfile="<log file location>"

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

        echo "Creating ODBC connection for: $($DSNName) " >> $Logfile
        echo "Database name : $($DBName)" >> $Logfile
        echo "Database Server name : $($ServerName)" >> $Logfile
        echo "Database User name : $($DBUserName)" >> $Logfile
        echo "Connection Driver : $($connectionDriver) " >> $Logfile

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

        CreateODBCDataSourcesConfig -DSNName $intODBCDataSourceList[0] -DBName $DBName -ServerName $DBDNSName -DBUserName $DBUserName -connectionDriver $driver -L  $Logfile

        CreateODBCDataSourcesConfig -DSNName $intODBCDataSourceList[1] -DBName $DBName -ServerName $DBDNSName -DBUserName $DBUserName  -connectionDriver $driver   -L  $Logfile

  }
  elseif ($Environment -eq "uat")
  {

        CreateODBCDataSourcesConfig -DSNName $uatODBCDataSourceList[0] -DBName $DBName -ServerName $DBDNSName -DBUserName $DBUserName  -connectionDriver $driver -L  $Logfile
        CreateODBCDataSourcesConfig -DSNName $intODBCDataSourceList[1] -DBName $DBName -ServerName $DBDNSName -DBUserName $DBUserName  -connectionDriver $driver  -L  $Logfile

  }

  elseif ($Environment -eq "prod")
  {

        CreateODBCDataSourcesConfig -DSNName $prodODBCDataSourceList[0] -DBName $DBName -ServerName $DBDNSName -DBUserName $DBUserName  -connectionDriver $driver -L $Logfile
        CreateODBCDataSourcesConfig -DSNName $prodODBCDataSourceList[1] -DBName $DBName -ServerName $DBDNSName -DBUserName $DBUserName  -connectionDriver $driver -L  $Logfile

      }

  else {
    echo  "Not a valid environment"  >> $Logfile
  }
 }
