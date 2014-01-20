#-----------------------------------------------------------------
# Title: User Management Script
# Created on : Jan 6th 2014
# Version: 2.0
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
	$group = [ADSI]"WinNT://$computer/$Group,group"
	$group.add("WinNT://$computer/$Name")
	#net localgroup $Group $Name /add
	$user.SetInfo()
}

$servers = Get-Content C:\Users\karthik.r\Desktop\Draker\Scripts\servers.txt

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
	    
	        Import-Csv C:\Users\karthik.r\Desktop\Draker\Scripts\users.csv | ForEach-Object {
		
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
	

		else

		{
	
			$users = Import-Csv C:\Users\karthik.r\Desktop\Draker\Scripts\users.csv | foreach {$_.Name.tostring()}
		
			$builtin = "Administrator", "cygserver_drakerwin", "Guest", "sshd";
		
			foreach ($duser in @($localusers))

			{

				if ($users -notcontains $duser)

				{
	
					if ($builtin -notcontains $duser)

					{

						write-host "User $duser doesn't exist in the list.Deleting user"
					
						$query = "Are you sure to delete the entered user?"
		
						$yes = new-Object System.Management.Automation.Host.ChoiceDescription "&Yes",`
							"Accepting to delete the user account"
				
						$no = new-Object System.Management.Automation.Host.ChoiceDescription "&No",`
							"Aborting the user deletion"
				
						$choices = [System.Management.Automation.Host.ChoiceDescription[]]($yes,$no)
		
						$answer = $host.ui.PromptForChoice($caption,$query,$choices,0)
		
						switch ($answer)
		
						{
		
							0 {"Deleting the user account....."}
			
							1 {"Aborting....."}
		
						}
		
						if ($answer -eq 0)

						{
		
							$comp = [ADSI]"WinNT://$computer"
		
							$comp.Delete("User", $duser)
			
							"User $duser removed successfully!!!"
		
						}
		
						else
		
							{"Task Aborted!!!"}
		
					}
				}
			}
		}
	}
}	
	
	