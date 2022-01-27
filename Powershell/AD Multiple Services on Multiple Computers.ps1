#Paramaters
<#
Param (
[Parameter(Mandatory=$true)]
[string[]]
${Service Name (Place ** around name for wild card search)}
)
#$Service = ${Service Name (Place ** around name for wild card search)}
#>

filter leftside{
param(
        [Parameter(Position=0, Mandatory=$true,ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [PSCustomObject]
        $obj
    )

    $obj|?{$_.sideindicator -eq '<='}

}

$header = @"
<style>

    h1 {

        font-family: Arial, Helvetica, sans-serif;
        color: #e68a00;
        font-size: 28px;

    }

    
    h2 {

        font-family: Arial, Helvetica, sans-serif;
        color: #000099;
        font-size: 16px;

    }

    
    
   table {
		font-size: 12px;
		border: 0px; 
		font-family: Arial, Helvetica, sans-serif;
	} 
	
    td {
		padding: 4px;
		margin: 0px;
		border: 0;
	}
	
    th {
        background: #395870;
        background: linear-gradient(#49708f, #293f50);
        color: #fff;
        font-size: 11px;
        text-transform: uppercase;
        padding: 10px 15px;
        vertical-align: middle;
	}

    tbody tr:nth-child(even) {
        background: #f0f0f2;
    }

        #CreationDate {

        font-family: Arial, Helvetica, sans-serif;
        color: #ff3300;
        font-size: 12px;

    }
.RunningStatus {
    color: #008000;
}

.StopStatus {
    color: #ff0000;
}    

</style>

"@

#Set New line using OFS special Powershell variable

$OFS = "`n"

#Externally set input value as string

[string[]] $_ServerList= @()

#Get the input from the user

$_ServerList = READ-HOST "Enter List Services"

#splitting the list of input as array by Comma & Empty Space

$_ServerList = $_ServerList.Split(',').Split(' ')
$Services = $_ServerList + $OFS
$Services

# Gets a list of Computers

$ComputerList = Get-ADComputer -Filter * -Properties Name,DistinguishedName | Sort-Object | Select-Object -Property Name,DistinguishedName
$ComputerSelect = $ComputerList | Out-GridView -Title "Select Computer Name and Click OK" -PassThru
Write-Host "Computer: " $ComputerSelect.Name

#Search for sevices on Selected Machine/s (non-terminating Error Messages Silenced)

$ADComputers = $ComputerSelect.Name
$OutputLoop = ForEach ($ADC in $ADComputers)
{
$ServiceList = Get-Service -Name $Services -ComputerName $ADC -ErrorAction SilentlyContinue | Select-Object -Property MachineName,Name,DisplayName,Status | Sort-Object 
 If (($ServiceList -ne $null) -and ($ServiceList.Status -like "Running") -or ($ServiceList.Status -like "Stopped")) 
    { 
     $ServiceList
    }

}


#Output machine/s that did not responded 

$Errs = Compare-Object -ReferenceObject $ComputerSelect.Name -DifferenceObject $OutputLoop.MachineName | leftside | Select-Object -Property *

#Output results as a HTML Report

$htmlreport1 = $OutputLoop | Convertto-html -Property MachineName,Name,DisplayName,Status -Fragment -PreContent "<h1>Services</h1>"
$htmlreport1 = $htmlreport1 -replace '<td>Running</td>','<td class="RunningStatus">Running</td>' 
$htmlreport1 = $htmlreport1 -replace '<td>Stopped</td>','<td class="StopStatus">Stopped</td>'
$htmlreport2 = $Errs | Convertto-html -Property * -Fragment -PreContent "<h2>Skipped Machines Due to Errors</h2>"
$report = convertto-html -Body "$htmlreport1 $htmlreport2" -Title "ADMultipleServicesMachines" -Head $header -PostContent "<p id='CreationDate'>Creation Date: $(Get-Date -Format dd/MM/yy)</p>"
$report | out-file .\ADMultipleServicesMachines.html
Invoke-Expression .\ADMultipleServicesMachines.html

Remove-Variable * -ErrorAction SilentlyContinue
