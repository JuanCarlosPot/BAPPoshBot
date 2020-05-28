function Remove-ADUser {
	<#
  .SYNOPSIS
      Removes an user from the domain
  .EXAMPLE
      !Remove-ADUser --DomainName JuanCarlosPot
	.EXAMPLE
			!Remove-ADUser --dname JuanCarlosPot --permaremove $true
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
		[Alias('dname')]
		[string]$DomainName,

		[Parameter(Position = 1)]
		[Alias('permaremove')]
		[boolean]$RemoveFromRecycleBin
	)

	Connect-MsolService -Credential $Credential

	$UserPrincipalName = ($DomainName -replace '\s','') + $Domain
	$Outputvariable = ''

	$Outputvariable = Get-MsolUser -UserPrincipalName $UserPrincipalName

	if ($RemoveFromRecycleBin) {
		Remove-MsolUser -UserPrincipalName $UserPrincipalName -Force -RemoveFromRecycleBin
	} else {
		Remove-MsolUser -UserPrincipalName $UserPrincipalName -Force
	}

	$r = [pscustomobject]@{
		FirstName = $Outputvariable.FirstName
		LastName = $Outputvariable.LastName
		SignInName = $Outputvariable.SignInName
	}

	New-PoshBotCardResponse -Title "User removed:  [$Outputvariable.DisplayName]" -Text ($r | Format-List -Property * | Out-String)

}
