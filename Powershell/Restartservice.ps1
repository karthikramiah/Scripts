$LogTime = Get-Date -Format "yyyyMMddhhmmss"
$logfile = 'C:\Users\karthik.r\Desktop\Draker\Scripts\'+"restart"+$LogTime+".log"
$srv = "BITS"

function LogInfo($message)
{
     $date= Get-Date
     $outContent = "[$date]`tInfo`t`t$message"
     Add-Content -path $logFile -value $outContent
}

function LogError($message)
{
     $date= Get-Date
     $outContent = "[$date]`tError`t`t$message"
     Add-Content -path $logFile -value $outContent
}

if($(Get-Service -Name $srv).status -ne "Running")
{
	LogError("$srv is already in Stopped state.Starting it up.")
	Start-Service -InputObject (get-Service -Name $srv)
	LogInfo("$srv service started successfully")
}
else
{
	LogInfo("Stopping $srv service")
	Stop-Service -InputObject (get-Service -Name $srv)
	if($(Get-Service -Name $srv).status -ne "Running")
	{
		LogInfo("$srv service stopped successfully")
	}
	else
	{
		LogInfo("Unable to Stop $srv.Killing the PID")
		$servicePID = (gwmi win32_Service | where { $_.Name -eq $srv}).ProcessID
		Stop-Process $ServicePID
		LogInfo("$srv running with PID:$servicePID has been killed")
	} 
	LogInfo("Starting $srv service")
	Start-Service -InputObject (get-Service -Name $srv)
	if ($(Get-Service -Name $srv).Status -eq "Running")
	{
		LogInfo("$srv service started successfully")
	}
	else
	{
		LogError ("Unable to start $srv Service")
    }    
}