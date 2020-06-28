cls
@()
$logfiles = @("C:\Users\r\Documents\z\dcdiag.txt","C:\Users\r\Documents\z\showrepl.txt","C:\Users\r\Documents\z\relsum.txt")
Write-Host "`n`n************************************ Color Codes Used ******************************************************" 
Write-Host "                      Passed Parameter Lines        ----- green Color" -ForegroundColor Green
Write-Host "                      Error  Parameter Lines        ----- Magenta Color" -ForegroundColor Magenta
Write-Host "                      Failed Healthcheck Parameters ----- Red Color" -ForegroundColor Red
Write-Host "************************************************************************************************************`n`n" 
foreach ($logfile in $logfiles){
   Write-Host "`n`n################################ Processing $logfile ##################################" -ForegroundColor Yellow
   $contentfile = get-content $logfile
   if($logfile -notlike $logfiles[2]){
   foreach($line in $contentfile) 
    {   if ($line -like "*.........*" -or $line -like "*succeed*")
            {if ($line -like "*fail*"){Write-Host $line -ForegroundColor Red}else{Write-Host $line -ForegroundColor Green}}
        if ($line -like "*Last attempt*" -or $line -like "*error*")
		    {   if ($line -like "*Success*" -or $line -like "*succeed*"){Write-Host $line -ForegroundColor Green}
                else{if($line -like "*error*"){Write-Host $line -ForegroundColor Magenta}else{Write-Host $line -ForegroundColor Red}}}
	}}else{
	    $count = 1
	    foreach($line in $contentfile){
		  if($count -gt 16){if($line -notlike "*0 /*"){
		     Write-Host $line -ForegroundColor Red}else{Write-Host $line -ForegroundColor Green}}
		  $count=$count+1
		}		
	}}

