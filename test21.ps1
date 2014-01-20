function Ensure-LocalUser
{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string] $userName,
        [Parameter(Mandatory=$true)]
        [string] $passWord
    )
    process{

        $objOu = [ADSI]"WinNT://${env:Computername}"
        $localUsers = $objOu.Children | where {$_.SchemaClassName -eq 'user'}  | Select {$_.name[0].ToString()} 

        if($localUsers -NotContains $userName)
        {
            $objUser = $objOU.Create("User", $userName)
            $objUser.setpassword($password)
            $objUser.SetInfo()
            $objUser.description = "CMM Test user"
            $objUser.SetInfo()

            return $true
        }
        else
        {
            return $false
        }

    }
}