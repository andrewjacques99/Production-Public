# Starting Message
Write-Output "Computer Name and Log Name are required inputs"


# Computer name input
$ComputerFilter = Read-Host -Prompt "Computer Name (Example: adxadk01)"


# Last x Minutes

$Minutes = 12000

# Start Search
$FormatEnumerationLimit = -1
$Seconds = $Minutes*60*1000
$Output=@()
$Computers = Get-ADComputer -Filter * | where {($_.Name -like $ComputerFilter) -and ($_.Name -notlike "*xx")}

# Log Name Input
$LogName = Read-Host -Prompt "Log Name (Example: Application)"

# Event ID Input
$EventID = Read-Host -Prompt "Event ID (Example: 3012)"

# Message Filter Input
$MessageFilter = Read-Host -Prompt "Message Filter (Example: * Wild Card or *Citrix*)"

# Different FilterPath depending on Input 
If ($EventID -eq "")
{$FilterPath = "*"}
Else
{$FilterPath = "*[System[EventID=" + $EventID + " and TimeCreated[timediff(@SystemTime) <= $Seconds]] ]"}

# Combined information to get data
foreach ($Computer in $Computers)
    {
    # Write-Host $Computer.name
    $Output += Get-WinEvent -ComputerName $Computer.Name -LogName $LogName -FilterXPath $FilterPath | Where {$_.Message -like $MessageFilter} | Select-Object TimeCreated, MachineName, ID, Message, UserID
    }
    $Output | Sort-Object TimeCreated | Out-GridView

# Clear all variables
Remove-Variable * -ErrorAction SilentlyContinue

