Function setBrightness
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [Alias("v")]
        [string]
        $AbsoluteBrightness
)

#set brightness using get-wmiobject
(Get-WmiObject -Namespace root/wmi WmiMonitorBrightnessMethods).wmisetbrightness(1,$AbsoluteBrightness)
Write-Host "Brightness set to $($AbsoluteBrightness)"
}