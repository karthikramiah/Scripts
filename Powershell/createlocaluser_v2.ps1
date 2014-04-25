param($computer="localhost")

Import-Csv users.csv | ForEach-Object {

$objOu = [ADSI]"WinNT://$computer"

$usr = $_.Name

#$colUsers = $computer.psbase.children |where{$_.psbase.schemaclassname -eq "User"} | foreach {$_.name[0].tostring() }

$colUsers = ($objComputer.psbase.children | Where-Object {$_.psBase.schemaClassName -eq "User"} | Select-Object -expand Name)

	if ($colUsers -NotContains $usr)
		
		{
		
			$objUser = $objOU.Create("User", $_.Name)

			$objUser.setpassword($_.Password)

			$objUser.SetInfo()

			$objUser.description= $_.Description

			$objUser.SetInfo()

			$objUser.UserFlags = 64 + 65536

			net localgroup $_.Group $_.Name /add
	
			$objUser.SetInfo()
		
		}
	
	else
	
		{
		
		"The user account exists."
		exit
		}

}		