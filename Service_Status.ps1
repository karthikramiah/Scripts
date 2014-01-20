$Computers = Get-Content C:\Scripts\servers.txt
foreach ($comp in $Computers)
{
Get-Service *CsiLoggernet* -computername $comp | Select name,status,machinename |sort machinename |format-table -autosize
}