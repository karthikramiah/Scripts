$servers = Get-content server.txt
foreach ($computer in $servers)
{
$adsi = [ADSI]"WinNT://$computer"
$users = $adsi.psbase.children | where {$_.psbase.schemaClassName -match "user"} 

foreach ($member in $users.psbase.syncroot)
{$member.name}
}