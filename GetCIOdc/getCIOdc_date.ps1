#simple PS script to get CIOdc for oneshot needs
#Mathieu GRIVOIS, 20210907 v2.3
$url = ''
#use $user to add plain text username
$user = $null
#use $pass to add plain text password
$pass = $null
$startTime = get-date
$date = get-date -uformat "%Y%m%d"# on PS5+, you can use "FileDate" as a format
#pattern of the filename
$file = ".\CIOdc$date.zip"

clear
#making password a secureString to pass to method if stored as plain text or prompt user for credentials
if ($user -ne $null -and $pass -ne $null) {
	$secpasswd = ConvertTo-SecureString $pass -AsPlainText -Force
	#buildind the credential object
	$credential = New-Object System.Management.Automation.PSCredential($user, $secpasswd)
}else{
	Write-Host "Merci de renseigner les identifiants de connexion"
	$credential = Get-Credential
	clear
}
Write-Host "Téléchargement de la dernière version de la CIOdc"
#getting the file
try {
	Invoke-RestMethod $url -Credential $credential -OutFile $file
}catch{
# Dig into the exception to get the Response details.
	# Note that value__ is not a typo.
	if ($_.Exception) { 
		Write-Host "Téléchargement impossible."
		Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__ 
		Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
	} else { 
		Write-Host "Distribution CIOdc téléchargée dans l'archive $file"
	}
}

#letting use know time taken for getting the file
Write-Host "Durée écoulée: $((Get-Date).Subtract($startTime).Seconds) second(s)"
# }
Read-host -Prompt "Appuyer sur entrée pour quitter"