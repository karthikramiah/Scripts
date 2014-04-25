param($computer="localhost")

Import-Csv users.csv | ForEach-Object {

$objOu = [ADSI]"WinNT://$computer"

 
	$objUser = $objOU.Create("User", $_.Name)

	$objUser.setpassword($_.Password)

	$objUser.SetInfo()

	$objUser.description= $_.Description

	$objUser.SetInfo()

	$objUser.UserFlags = 64 + 65536

	net localgroup $_.Group $_.Name /add
	
	$objUser.SetInfo()
	
} 