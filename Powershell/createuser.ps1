Function Createuser([$$Name)

{
	$computerName = $env:ComputerName

	$comp = [ADSI]"WinNT://$computerName"
	
	$user = $comp.Create("User", $Name)
	
	#$user.SetPassword($Password)
	
	$user.SetInfo()
	
	#$user.Description= $Description

	#$user.SetInfo()
	
	$user.UserFlags = 64 + 65536

	#net localgroup $Group $Name /add
	
	$user.SetInfo()
	
}

Createuser user2
 
 
