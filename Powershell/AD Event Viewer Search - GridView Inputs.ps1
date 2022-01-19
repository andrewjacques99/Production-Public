# Gets a list of Computers
$ComputerList = Get-ADComputer -Filter * -Properties Name,DistinguishedName | Sort-Object | Select-Object -Property Name,DistinguishedName
$ComputerSelect = $ComputerList | Out-GridView -Title "Select Computer Name and Click OK" -OutputMode Single


# Gets a list of Event Log Names
$LogNameList = Get-EventLog -LogName * -ComputerName $ComputerSelect.Name | Sort-Object | Select-Object -Property Log
$LogSelect = $LogNameList | Out-GridView -Title "Select Log Name and Click OK" -OutputMode Single

# Gets a list of the Event ID's
$EventNameList = Get-WinEvent -LogName $LogSelect.Log -ComputerName $ComputerSelect.Name | Sort-Object | Select-Object -Property ProviderName,ID,Message
$EventNameSelect = $EventNameList | Out-GridView -Title "Select Event Number and Click OK" -OutputMode Single

# Combineds the above and outputs
$GetLogEvent = Get-WinEvent -LogName Application -ComputerName ATGRDDK01 | Where-Object ID -eq $EventNameSelect.Id
$GetLogEvent

# Clears all the variables
Remove-Variable * -ErrorAction SilentlyContinue
