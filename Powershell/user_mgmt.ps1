#-----------------------------------------------------------------
# Title: User Management Script
# Created on : Jan 20th 2014
#-----------------------------------------------------------------



Function Createuser ($Name, $Password, $Group, $Description)
{
    
    $comp = [ADSI]"WinNT://$computer"
	$user = $comp.Create("User", $Name)
	$user.SetPassword($Password)
	$user.SetInfo()
	$user.Description= $Description
	$user.SetInfo()
	$user.UserFlags = 64 + 65536
	if ($Group -ne 'Administrators') 
    {
		$rdu = [ADSI]("WinNT://$computer/Remote Desktop Users")
		$rdu.add("WinNT://$computer/$Name") 
    }
    $group = [ADSI]"WinNT://$computer/$Group,group"
	$group.add("WinNT://$computer/$Name")
    $user.SetInfo()
}

#Update the servers list here

$servers = Get-Content servers.txt

$title = "Local User Account Management"

$message = "Do you want to Create or Delete local users?"

$create = New-Object System.Management.Automation.Host.ChoiceDescription "&Create", `
    "Creates new local users in the host."

$delete = New-Object System.Management.Automation.Host.ChoiceDescription "&Delete", `
    "Deletes Existing local users from the host."

$options = [System.Management.Automation.Host.ChoiceDescription[]]($create, $delete)

$choice = $host.ui.PromptForChoice($title, $message, $options, 0) 

switch ($choice)
    
	{
    
		0 {"You selected to Create New Local User Accounts."}
        
		1 {"You selected to Delete Local User Accounts."}
    
	}

foreach ($computer in $servers)
	
	{
	
		if ($choice -eq 0) 

		{
			#Uppdate the userlist here
	        
			Import-Csv users.csv | ForEach-Object {
		
			$adsi = [ADSI]"WinNT://$computer"
			
			$localusers = $adsi.psbase.children | where {$_.psbase.schemaClassName -match "user"} | foreach {$_.name[0].tostring() }
	    
			if ($localusers -contains $_.Name)
			
				{
				
					$usr = $_.Name
		
					Write-Host "User Account:$usr Already exists...." -BackgroundColor "Red" -ForegroundColor "Black"
				
				}
		
			else	
		
				{
		
					$usr = $_.Name
					
					Createuser $_.Name $_.Password $_.Group $_.Description
					
					                          
						
					
					Write-Host "User $usr added successfully to $computer" -BackgroundColor "Green" -ForegroundColor "Black"
		
				}
		
		}
	}

else

	{
	
		$adsi = [ADSI]"WinNT://$computer"
		
		$localusers = $adsi.psbase.children | where {$_.psbase.schemaClassName -match "user"} | foreach {$_.name[0].tostring()}
		
		$users = Import-Csv users.csv | foreach {$_.Name.tostring()}
		
		# Add all the Built-in accounts here

		$builtin = "Administrator", "cyg_server", "Guest", "sshd", "LoggerNet", "SvcCWRSYNC", "Rack", "537551-admin", "555051-admin", "555050-admin";

		foreach ($duser in @($localusers))

		{

			if (($users -notcontains $duser) -and ($builtin -notcontains $duser))

			{
				
				write-host "User $duser doesn't exist in the Users list.Deleting user" -BackgroundColor "Red" -ForegroundColor "Black"
				
				$adsi.Delete("User", $duser)
			
				write-host "$duser deleted successfully" -BackgroundColor "Green" -ForegroundColor "Black"
				
			}	
			
		}
	
	}

}