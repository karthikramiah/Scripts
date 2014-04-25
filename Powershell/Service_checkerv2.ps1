#NAME: Windows Service Checker

#DATE: 17/01/2014

#VERSION : 3.0

#Please make sure that the servers.txt exists populated with all the server hostnames

function Sendmail ($Subject, $Body) 

{

	$EmailFrom = "drakeralerts@gmail.com"
	$Emailid = "karthik.r@gquotient.com";
	$SMTPServer = "smtp.gmail.com" 
	$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer) 
	$SMTPClient.EnableSsl = $true 
	$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("drakeralerts", "alert@draker"); 
	foreach ($EmailTo in $Emailid)
	{
		$SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)
	}
}

$Servers = Get-Content C:\Users\karthik.r\Desktop\Draker\Scripts\servers.txt

foreach ($Computer in $Servers)

{

	#Create an array of all services running

	$GetService = get-service -ComputerName $Computer

	#Create a subset of the previous array for services you want to monitor

	# Mention Your services here

	#$ServiceArray = "CsiLoggernet","darker_watcher.csi.core";
	$ServiceArray = "BITS";
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

					$Subject = "$srv is hung on $Computer"
					
					$Body = "The $srv service was found hung. Restarting the Service."
					
					Sendmail $Subject $Body
					
					$servicePID = (gwmi win32_Service | where { $_.Name -eq $srv}).ProcessID

					Stop-Process $ServicePID

					Start-Service -InputObject (get-Service -ComputerName $Computer -Name $srv)

				}

				# check if a service is stopped

				elseif ($Service.status -eq "Stopped")

				{
					echo $Service.status
					#email to notify if a service is down

					$Subject = "$srv is stopped on $Computer"
					
					$Body = "The $srv service was found stopped. Starting the Service."
					
					Sendmail $Subject $Body
					
					#automatically restart the service.

					Start-Service -InputObject (get-Service -ComputerName $Computer -Name $srv)

				}

			}

		}

	}

}