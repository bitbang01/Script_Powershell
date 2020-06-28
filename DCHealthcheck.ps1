@()
$logfiles = @("C:\Users\$env:username\Desktop\dcdiag.txt","C:\Users\$env:username\Desktop\showrepl.txt","C:\Users\$env:username\Desktop\replsum.txt")
Write-Host "`n`n************************************ DC Healthcheck Color Codes ********************************************" -ForegroundColor Cyan
Write-Host "                      #Green Display Color    -----  Passed Healthcheck Parameters    " -ForegroundColor Green
Write-Host "                      #Magenta Display Color  -----  Error  Healthcheck Parameters    " -ForegroundColor Magenta
Write-Host "                      #Red Display Color      -----  Failed Healthcheck Parameters    " -ForegroundColor Red
Write-Host "************************************************************************************************************`n`n" -ForegroundColor Cyan
netdom query fsmo
dcdiag /v > C:\Users\$env:username\Desktop\dcdiag.txt
repadmin /showrepl >C:\Users\$env:username\Desktop\showrepl.txt
foreach ($logfile in $logfiles){
   Write-Host "`n`n################################# Running Healthcheck Command #######################################" -ForegroundColor Yellow
   Write-Host "################################ Processing $logfile #######################`n`n" -ForegroundColor Yellow
   if($logfile -notlike $logfiles[2]){
      $contentfile = get-content $logfile
   foreach($line in $contentfile) 
    {   if ($line -like "*via RPC*"){Write-Host $line -ForegroundColor cyan}
	    if ($line -like "*.........*" -or $line -like "*succeed*")
            {if ($line -like "*fail*"){Write-Host $line -ForegroundColor Red}else{Write-Host $line -ForegroundColor Green}}
        if ($line -like "*Last attempt*" -or $line -like "*error*")
		    {   if ($line -like "*Success*" -or $line -like "*succeed*"){Write-Host $line -ForegroundColor Green}
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
	
