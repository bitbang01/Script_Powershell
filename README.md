# Visit:
* [Github Pages Link](https://www.github.com/bitbang01)
* [LinkedIn Profile](https://www.linkedin.com/in/nrajput-pshadow)
* [Twitter @*****](https://twitter.com/****)

# Script_Powershell
# Title: Domain Controller Healthchecks Script

# How it works:
  1. Commands used in the script are only for healthchecks. No changes triggered to the environment.
  2. Script is combination of 5-6 DC Healthcheck commands
  3. Each command's text output file will be stored on your Desktop location
  4. Script will read the files and show relevent information related to the Healthcheck and removed extra lines of information which consumes time
  
# Achievement:
A lot of time can be saved as reading each file output manually will consume time

# Commands Used in the Script:
* netdom query fsmo
* repadmin /kcc 
* dcdiag /v 
* dcdiag /test:replications
* dcdiag /test:netlogons
* dcdiag /test:knowsofroleholders /v
* repadmin /showrepl
* Repadmin /viewlist *

# What Next:
  * Proper Documentation still pending
  * Create GUI Interface for all DC related healthchecks and information
  * Happy to work with collaborators: Lets take the project to next BitBang
  
  
