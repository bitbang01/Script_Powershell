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
			
function Check-Services{
Write-Host "`n `n ########################################### Checking Essential Services Running Status #############################" -ForegroundColor Yellow
Write-Host "################################################################################################################## `n" -ForegroundColor Yellow
	
        $serviceNames ='NETLOGON','KDC','ADWS','DNS'
        foreach($serviceName in $serviceNames){
        If (Get-Service $serviceName -ErrorAction SilentlyContinue) {
        If ((Get-Service $serviceName).Status -eq 'Running') {
        Write-Host "`n         $serviceName Service is running" -foregroundcolor green      } 
        Else { Write-Host "`n         $serviceName Service found, but it is not running." -foregroundcolor red    }    } 
        Else {  Write-Host "`n         $serviceName Service is not installed on the machine" -foregroundcolor red }
    }
}

function Check-sysvolnetlogon{
Write-Host "`n`n######################################## Checking SMBShare #######################################" -ForegroundColor Yellow
Write-Host "################################################################################################################## `n" -ForegroundColor Yellow

Get-SMBShare > C:\Users\$env:username\Desktop\healthcheck.txt
$smboutfile = get-content C:\Users\$env:username\Desktop\healthcheck.txt

foreach($lne in $smboutfile){
if($lne -like "*SYSVOL*" -or $lne -like "*NETLOGON*" ){write-host $lne -ForegroundColor Green}
else{write-host $lne}
}

$emptypath = get-smbshare |Where-Object path -eq "" | select name 
foreach($path in $emptypath.name){
if($path -eq "SYSVOL"){ write-host "SYSVOL folder path is missing" -foregroundcolor red}	
if($path -eq "NETLOGON"){ write-host "NETLOGON folder path is missing" -foregroundcolor red}	

}	

$AAA = Get-ChildItem -Path C:\Users\$env:username\Desktop\healthcheck.txt |Select-String -Pattern 'SYSVOL'
if($AAA.Matches.Length -eq 0){write-host "SYSVOL share is not available on the machine" -foregroundcolor red}

$BBB = Get-ChildItem -Path C:\Users\$env:username\Desktop\healthcheck.txt |Select-String -Pattern 'NETLOGON'
if($BBB.Matches.Length -eq 0){write-host "NETLOGON Share is not available on the machine" -foregroundcolor red}
}

function perform-Healthcheck{
cls
Run-BasicChecks
Run-kccHealthcheck
Check-Services
Check-sysvolnetlogon
Read-ResultFiles
View-DCList


}

perform-Healthcheck      
