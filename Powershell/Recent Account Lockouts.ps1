$DCList = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()

foreach ($DC in $DCList.DomainControllers)
    {
    $DC.Name
    Get-WinEvent -ComputerName $DC.Name -LogName Security -FilterXPath "*[System[EventID=4740 and TimeCreated[timediff(@SystemTime) <= 36000000]] ]" -ErrorVariable +errs -ErrorAction SilentlyContinue |
    Select-Object @{Name='Lockout Time';Expression={$_.TimeCreated}},@{Name='User Name';Expression={$_.Properties[0].Value}},@{Name='Source Host';Expression={$_.Properties[1].Value}} | ft -AutoSize
   Set-ExecutionPolicy Unrestricted }
