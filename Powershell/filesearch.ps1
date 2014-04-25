$Servers = Get-Content C:\Users\karthik.r\Desktop\Draker\Scripts\servers.txt

foreach ($Computer in $Servers)
{
	write-Host "---------------------------------------------" -ForegroundColor Yellow 
	$filePath = Read-Host "Please Enter File Path to Search" 
	write-Host "---------------------------------------------" -ForegroundColor Green 
	$fileName = Read-Host "Please Enter File Name to Search" 
	write-Host "---------------------------------------------" -ForegroundColor Yellow 
	"`n" 
	write-host "Searching in: $Computer" -ForegroundColor Blue
	
	Get-ChildItem -Recurse -Force $filePath -ErrorAction SilentlyContinue | Where-Object { ($_.PSIsContainer -eq $false) -and  ( $_.Name -like "*$fileName*") } | Select-Object Name,Directory| Format-Table -AutoSize * 
 

 }
