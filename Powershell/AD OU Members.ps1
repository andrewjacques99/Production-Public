$OUList = Get-ADOrganizationalUnit -Filter * -Properties Name,DistinguishedName | Select-Object -Property Name,DistinguishedName

$OU = $OUList | Out-GridView -Title "Select OU and Click OK" -OutputMode Single
$ADUserFilter = "*"


$ADUsers = Get-ADUser -SearchBase $OU.DistinguishedName -Filter $ADUserFilter

foreach ($ADUser in $ADUsers)
    {
    Write-Host $ADUser.Name
    }
Clear-Variable ADuser