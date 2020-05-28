function Add-ADUser {
	<#
  .SYNOPSIS
      Adds an user from the domain
  .EXAMPLE
      !Add-ADUser --FirstName JuanCarlos --LastName Pot
	.EXAMPLE
			!Add-ADUser --fname JuanCarlosPot --lname Pot --DomainName JuanCarlosP
  #>
	[PoshBot.BotCommand(Permissions = ('domain-admin'))]
	[CmdletBinding()]
	param(
		[PoshBot.FromConfig('Domain')]
		[Parameter(DontShow, Mandatory)]
		[string]$Domain,

		[PoshBot.FromConfig('Credential')]
		[Parameter(DontShow, Mandatory)]
		[pscredential]$Credential,

		[Parameter(Mandatory,Position = 0)]
		[Alias('fname')]
		[string]$FirstName,

		[Parameter(Mandatory,Position = 1)]
		[Alias('lname')]
		[string]$LastName,

		[Parameter(Position = 2)]
		[Alias('dname')]
		[string]$DomainName
	)

	Connect-MsolService -Credential $Credential

	$Outputvariable = ''

	$DisplayName = $FirstName + ' ' + $LastName

	if ($DomainName) {
		$UserPrincipalName = ($DomainName -replace '\s','') + $Domain
	} else {
		$UserPrincipalName = ($FirstName -replace '\s','') + ($LastName -replace '\s','') + $Domain
	}

	$Outputvariable = New-MsolUser -UserPrincipalName $UserPrincipalName -DisplayName $DisplayName -FirstName $FirstName -LastName $LastName -ForceChangePassword $true -StrongPasswordRequired $true

	$r = [pscustomobject]@{
		FirstName = $Outputvariable.FirstName
		LastName = $Outputvariable.LastName
		SignInName = $Outputvariable.SignInName
		Password = $Outputvariable.Password
	}

	New-PoshBotCardResponse -Title "New user created:  [$DisplayName]" -Text ($r | Format-List -Property * | Out-String) -DM
}
