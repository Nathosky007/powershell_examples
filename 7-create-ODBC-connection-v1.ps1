$Logfile="C:\Users\SainathM\Desktop\master-output-file.txt"

echo "################################################" >> $Logfile
$Application="app1"
$Environment="int"

$ODBCDSNName=@("${Application}.${Environment}.name1","${Application}.${Environment}.name2","${Application}.${Environment}.name3")

#Data source name list for all environments for PSV database
$ServerName = "awss.infra.saas"
$driver="SQL Server"

echo "Creation of ODBC DSNs started" >> $Logfile

CreateODBCDataSources -DSNName $ODBCDSNName[0] -DBName $LNDBName -ServerName $ServerName -connectionDriver $driver -L $Logfile
echo "Creation of $($ODBCDSNName[0]) ODBC DSN completed" >> $Logfile


Function CreateODBCDataSources
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
        $connectionDriver,

        [Parameter(Mandatory=$false)]
        [Alias("L")]
        [string]
        $Logfile
    )

        echo  "Creating ODBC connection for: $($DSNName) " >> $Logfile
        echo  "Database name : $($DBName)" >> $Logfile
        echo  "Database Server name : $($ServerName)" >> $Logfile
        echo   "Connection Driver : $($connectionDriver) " >> $Logfile

        ##For 64-bit connection setup
        $HKLMPath1 = "HKLM:\SOFTWARE\Wow6432Node\ODBC\ODBC.INI\" + $DSNName
        $HKLMPath2 = "HKLM:\SOFTWARE\Wow6432Node\ODBC\ODBC.INI\ODBC Data Sources"


        md $HKLMPath1 -ErrorAction silentlycontinue
        Set-ItemProperty -path $HKLMPath1 -name Driver -value (Get-ItemProperty "HKLM:\SOFTWARE\Wow6432Node\ODBC\ODBCINST.INI\$($connectionDriver)").Driver
        Set-ItemProperty -path $HKLMPath1 -name Description -value $DSNName
        Set-ItemProperty -path $HKLMPath1 -name Server -value $ServerName
        # Set-ItemProperty -path $HKLMPath1 -name Trusted_Connection -value "Yes"
        Set-ItemProperty -path $HKLMPath1 -name Database -value $DBName

        ## This is required to allow the ODBC connection to show up in the ODBC Administrator application.
        md $HKLMPath2 -ErrorAction silentlycontinue
        Set-ItemProperty -path $HKLMPath2 -name $DSNName -value $connectionDriver

    		echo   "64-bit installation completed " >> $Logfile

        #For 32-bit connection setup
        $HKLMPath32BitPath_2 = "HKLM:\SOFTWARE\ODBC\ODBC.INI\ODBC Data Sources"
    		$HKLMPath32BitPath_1 = "HKLM:\SOFTWARE\ODBC\ODBC.INI\" + $DSNName


        md $HKLMPath32BitPath_1 -ErrorAction silentlycontinue
        Set-ItemProperty -path $HKLMPath32BitPath_1 -name Driver -value (Get-ItemProperty "HKLM:\SOFTWARE\ODBC\ODBCINST.INI\$($connectionDriver)").Driver
        Set-ItemProperty -path $HKLMPath32BitPath_1 -name Description -value $DSNName
        Set-ItemProperty -path $HKLMPath32BitPath_1 -name Server -value $ServerName
        # Set-ItemProperty -path $HKLMPath1 -name Trusted_Connection -value "Yes"
        Set-ItemProperty -path $HKLMPath32BitPath_1 -name Database -value $DBName

        ## This is required to allow the ODBC connection to show up in the ODBC Administrator application.
        md $HKLMPath32BitPath_2 -ErrorAction silentlycontinue
        Set-ItemProperty -path $HKLMPath32BitPath_2 -name $DSNName -value $connectionDriver


}
