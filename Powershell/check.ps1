$logfile = 'C:\Users\karthik.r\Desktop\Draker\Scripts\check.log'
$srv="BITS"
function LogInfo($message)
{
     $date= Get-Date
     $outContent = "[$date]`tInfo`t`t$message"
     Add-Content -path $logFile -value $outContent
}

if($(Get-Service -Name $srv).status -ne "Running")
{
LogInfo("$srv service is in stopped state")
}
else
{
LogInfo("$srv service is in running state")
}