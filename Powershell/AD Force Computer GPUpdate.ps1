# Gets a list of Computers
$ComputerList = Get-ADComputer -Filter * -Properties Name,DistinguishedName | Sort-Object | Select-Object -Property Name,DistinguishedName
$ComputerSelect = $ComputerList | Out-GridView -Title "Select Computer Name and Click OK" -OutputMode Single
Write-Host "Computer: " $ComputerSelect.Name

foreach ($Server in $ComputerSelect)
    {
    Invoke-Command -ComputerName $Server.Name -ScriptBlock {Gpupdate /Force}
    Invoke-Command –ScriptBlock {GPResult /r /SCOPE COMPUTER} –ComputerName $Server.Name
    }
