#NAME: Windows Service Checker

#DATE: 16/01/2014

#VERSION : 2.0

#Please make sure that the servers.txt exists populated with all the server hostnames

$Servers = Get-Content C:\Scripts\servers.txt

foreach ($Computer in $Servers)

{

	#Create an array of all services running

	$GetService = get-service -ComputerName $Computer

	#Create a subset of the previous array for services you want to monitor

	# Mention Your services here

	$ServiceArray = "CsiLoggernet","darker_watcher.csi.core";

	#Find any service that is stopped

	foreach ($Service in $GetService)

	{
		foreach ($srv in $ServiceArray)

		{

			if ($Service.name -eq $srv)

			{

				#check if a service is hung

				if ($Service.status -eq "StopPending")

				{

					#email to notify if a service is down

					Send-Mailmessage -from "$Computer@drakerenergy.com"  -To "ed.brady@drakerenergy.com" -Subject "$srv is hung on $Computer" -Body "The $srv service was found hung. Restarting the Service." -SmtpServer smtp.secureserver.net

					$servicePID = (gwmi win32_Service | where { $_.Name -eq $srv}).ProcessID

					Stop-Process $ServicePID

					Start-Service -InputObject (get-Service -ComputerName $Computer -Name $srv)

				}

				# check if a service is stopped

				elseif ($Service.status -eq "Stopped")

				{

					#email to notify if a service is down

					Send-Mailmessage -from "$Computer@drakerenergy.com" -To "ed.brady@drakerenergy.com"  -Subject "$srv is stopped on $Computer"  -Body "The $srv service was found stopped.Starting the Service" -SmtpServer smtp.secureserver.net

					#automatically restart the service.

					Start-Service -InputObject (get-Service -ComputerName $Computer -Name $srv)

				}

			}

		}

	}

}