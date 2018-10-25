Function EnableTLS {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Alias("V")]
        [string]
        $tlsVersion
        
    )
    
    #create registry paths for TLS 1.0,1.1, 1.2

    if ( $tlsVersion -eq "1.0" ) 
    {
        $tlsVersion = "TLS 1.0"
        
        CreateTLSRegistryValues -V $tlsVersion
        Write-Host "[ Reg ] TLS Version 1.0 enabled" 
    }
    if ( $tlsVersion -eq "1.1" ) 
    {
        $tlsVersion = "TLS 1.1"
        
        CreateTLSRegistryValues -V $tlsVersion
        Write-Host "[ Reg ] TLS Version 1.1 enabled" 
    }
    elseif ( $tlsVersion -eq "1.2" ) 
    {
        $tlsVersion = "TLS 1.2"

        CreateTLSRegistryValues -V $tlsVersion
        Write-Host "[ Reg ] TLS Version 1.2 selected" 
    }
    else {
        Write-Host "[ Reg ] No TLS Version enabled" 
    } 
 
    Write-Host "Completed registry settings for TLS 1.1 and TLS 1.2" 
}

Function CreateTLSRegistryValues {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [Alias("V")]
        [string]
        $tls_Version

    )

    $registry_path="HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\"

    New-Item -Path $registry_path -name $tlsVersion
    $tls_Version_registry_path = Join-Path -Path $registry_path $tls_Version
    #Create keys for Client, Server
    New-Item -Path $tls_Version_registry_path -name "Client"
    Write-Host "[ Reg ] Client key added for $($tls_Version_registry_path)" 

    #Create fields DisabledByDefault,Enabled for Client
    New-ItemProperty -Path (Join-Path -Path $($tls_Version_registry_path) "Client") -Name "DisabledByDefault" -Value "0" -PropertyType DWord -Force
    Write-Host "[ Reg ] DisabledByDefault field added to Client" 

    New-ItemProperty -Path (Join-Path -Path $($tls_Version_registry_path) "Client") -Name "Enabled" -Value "1" -PropertyType DWord -Force
    Write-Host "[ Reg ] Enabled field added to Client" 

    #Create fields DisabledByDefault,Enabled for Server
    New-Item -Path $tls_Version_registry_path -name "Server"
    Write-Host "[ Reg ] Server key added for $($tls_Version_registry_path)" 

    New-ItemProperty -Path (Join-Path -Path $($tls_Version_registry_path) "Server") -Name "DisabledByDefault" -Value "0" -PropertyType DWord -Force
    Write-Host "[ Reg ] DisabledByDefault field added to Server" 

    New-ItemProperty -Path (Join-Path -Path $($tls_Version_registry_path) "Server") -Name "Enabled" -Value "1" -PropertyType DWord -Force
    Write-Host "[ Reg ] Enabled field added to Server" 

}


#enable TLS 1.0,1.1, 1.2
EnableTLS -V "1.0"
EnableTLS -V "1.1"
EnableTLS -V "1.2" 