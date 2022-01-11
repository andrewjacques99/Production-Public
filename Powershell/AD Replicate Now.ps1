$DC = Get-ADDomainController -Discover -Service PrimaryDC

repadmin /syncall $DC /AedP | Out-Null
repadmin /syncall $DC /Aed  | Out-Null

repadmin /showrepl| ConvertFrom-Csv 
"`n"
repadmin /queue $DC
