Function Get-LocalUserAccount{
[CmdletBinding()]
param (
 [parameter(ValueFromPipeline=$true,
   ValueFromPipelineByPropertyName=$true)]
 [string[]]$ComputerName=$env:computername,
 [string]$UserName
)
foreach ($comp in $ComputerName){

    [ADSI]$server="WinNT://$comp"

    if ($UserName){

            foreach ($User in $UserName){
            $server.children |
            where {$_.schemaclassname -eq "user" -and $_.name -eq $user}
            }    
    }else{

            $server.children |
            where {$_.schemaclassname -eq "user"}
        }
    }
}