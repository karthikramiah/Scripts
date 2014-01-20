Function Deleteuser($ServerIP, $Name)

{

	$comp = [ADSI]"WinNT://$ServerIP"

	$user = $comp.Delete("User", $Name)

}

Deleteuser 127.0.0.1 testuser