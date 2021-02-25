
function Run-BasicChecks{

Write-Host "`n`n########################################## Netdom Query FSMO #####################################################" -ForegroundColor Yellow
Write-Host "################################################################################################################## `n" -ForegroundColor Yellow
netdom query fsmo  >C:\Users\$env:username\Desktop\healthcheck.txt
read-file
Write-Host "`n`n########################################## Running repadmin /kcc #################################################" -ForegroundColor Yellow
Write-Host "################################################################################################################## `n" -ForegroundColor Yellow
repadmin /kcc >C:\Users\$env:username\Desktop\healthcheck.txt
read-file

}

function read-file{
$healthfile = get-content C:\Users\$env:username\Desktop\healthcheck.txt
foreach($lne in $healthfile){
if($lne -notlike "*fail*"){
if($lne -notlike "*error*"){
if($lne -like "*success*" -or $lne -like "*pass*"){write-host $lne -ForegroundColor Green }
else{write-host $lne -ForegroundColor Cyan}}
else {write-host $lne -ForegroundColor magenta}}
else{write-host $lne -ForegroundColor Red}
}}


function Run-kccHealthcheck{
dcdiag /v > C:\Users\$env:username\Desktop\dcdiag.txt
repadmin /showrepl >C:\Users\$env:username\Desktop\showrepl.txt
}


function Read-ResultFiles
{
@()
$logfiles = @("C:\Users\$env:username\Desktop\dcdiag.txt","C:\Users\$env:username\Desktop\showrepl.txt","C:\Users\$env:username\Desktop\replsum.txt")

foreach ($logfile in $logfiles){
   Write-Host "`n `n ################################ Processing $logfile #################################" -ForegroundColor Yellow
   Write-Host "##################################################################################################################`n`n" -ForegroundColor Yellow
   if($logfile -notlike $logfiles[2]){
      $contentfile = get-content $logfile
   foreach($line in $contentfile) 
    {   if ($line -like "*via RPC*"){Write-Host $line -ForegroundColor cyan}
	    if ($line -like "*.........*" -or $line -like "*succeed*")
            {if ($line -like "*fail*"){Write-Host $line -ForegroundColor Red}else{Write-Host $line -ForegroundColor Green}}
        if ($line -like "*Last attempt*" -or $line -like "*error*")
		    {   if ($line -like "*was Success*" -or $line -like "*succeed*"){Write-Host $line -ForegroundColor Green}
                else{if($line -like "*error*"){Write-Host $line -ForegroundColor Magenta}else{Write-Host $line -ForegroundColor Red}}}
	}}else{
	    Write-Host "              This Command(repadmin /replsum) takes time. Please wait for the command to complete" -ForegroundColor Cyan
        $count = 1
        repadmin /replsum >C:\Users\$env:username\Desktop\replsum.txt
        $contentfile = get-content $logfile
	    foreach($line in $contentfile){
		  if($count -gt 16){if($line -notlike "*0 /*"){
		     Write-Host $line -ForegroundColor Red}else{Write-Host $line -ForegroundColor Green}}
		  $count=$count+1
		}		
}}

}

function View-DCList{
Write-Host "`n`n######################################## Running dcdiag /test:replications #######################################" -ForegroundColor Yellow
Write-Host "################################################################################################################## `n" -ForegroundColor Yellow
dcdiag /test:replications  >C:\Users\$env:username\Desktop\healthcheck.txt
read-file
Write-Host "`n`n######################################## Running dcdiag /test:netlogons #######################################" -ForegroundColor Yellow
Write-Host "################################################################################################################## `n" -ForegroundColor Yellow
dcdiag /test:netlogons  >C:\Users\$env:username\Desktop\healthcheck.txt
read-file
Write-Host "`n `n ########################################### List of Domain Controllers ###########################################" -ForegroundColor Yellow
Write-Host "################################################################################################################## `n" -ForegroundColor Yellow
$t = $host.ui.RawUI.ForegroundColor
$host.ui.RawUI.ForegroundColor = “Cyan”
Repadmin /viewlist * 
$host.ui.RawUI.ForegroundColor = $t           
            }  	
	
function perform-Healthcheck{
Run-BasicChecks
Run-kccHealthcheck
Read-ResultFiles
View-DCList
}

perform-Healthcheck
