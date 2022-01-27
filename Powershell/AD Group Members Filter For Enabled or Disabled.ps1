#Gets a list of Groups
$GroupList = Get-ADGroup -Filter * -Properties Name,DistinguishedName | Sort-Object  | Select-Object -Property Name,DistinguishedName

#Create a Gridview list of Groups, to uses as a selection
$Group = $GroupList | Out-GridView -Title "Select Group and Click OK" -OutputMode Single

#Gets the AD Group members SamAccoountName as per the Group selected, converts the Output to a String
$ADGroupMember = @(Get-ADGroupMember -identity $Group.Name | Select-Object -Property SamAccountName | select -ExpandProperty SamAccountName -Unique | Out-String -stream)

$FilterPick = Read-Host "Type Enabled or Disabled (Default is Enabled)"
If ([string]::IsNullOrWhiteSpace($FilterPick))
{
$FilterOption = $True
}
ElseIf ($FilterPick -eq 'Enabled')
{
$FilterOption = $True
}
Else
{
$FilterOption = $False
}


$Group.DistinguishedName
Write-Host "------------"

#Check each SamAccountName againest the Active Driectory and display the Name, Account Status and Last Log on Date
ForEach ($ADUser in $ADGroupMember)
{
$ADListUsers = Get-ADUser $ADUser -Properties LastLogOnDate | Where {$_.Enabled -eq $FilterOption} | Select-Object -Property Name,Enabled,LastLogOnDate
$ADListUsers
}

#If "Cannot find an object with identity: SamAccountName", this is probally another Group, check your AD to confirm

#Clears the Variables, this stops any issue with the variables bring back any previous held information
Remove-Variable * -ErrorAction SilentlyContinue