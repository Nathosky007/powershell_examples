[CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [Alias("val")]
        [string]
        $AbsoluteBrightness
)

. ("E:\git_labs_022018\powershell_examples\function-library.ps1")
if ( $AbsoluteBrightness -eq '0' ) {
    setBrightness -v $AbsoluteBrightness
    }
elseif ($AbsoluteBrightness -eq '30') {
    setBrightness -v $AbsoluteBrightness
    }
elseif ($AbsoluteBrightness -eq '50') {
    setBrightness -v $AbsoluteBrightness 
    }
elseif ($AbsoluteBrightness -eq '70') {
    setBrightness -v $AbsoluteBrightness  
    }
elseif ($AbsoluteBrightness -eq '90') {
    setBrightness -v $AbsoluteBrightness  
    }
elseif ($AbsoluteBrightness -eq '100') {
    setBrightness -v $AbsoluteBrightness  
    }

