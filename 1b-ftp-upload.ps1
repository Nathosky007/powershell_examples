$File = "C:\Users\User1\powershell_examples\powershell_examples\dummy-file.txt"
$ftp = "ftp://Admin01:K2qwert@ec2-192-168-100-101.ap-southeast-2.compute.amazonaws.com/home/ftp_user//dummy-file.txt"

"ftp url: $ftp"

$webclient = New-Object System.Net.WebClient
$uri = New-Object System.Uri($ftp)

"Uploading $File..."

$webclient.UploadFile($uri, $File)
