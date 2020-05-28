function Get-ADUser {
	<#
  .SYNOPSIS
      Get the defined AD user(s)
  .EXAMPLE
      !Get-ADUser --DomainName JuanCarlosPot
			Gets the specified user.
	.EXAMPLE
		  !Get-ADUser
			Gets all the users
  #>
	[PoshBot.BotCommand(Permissions = ('domain-admin'))]
	[CmdletBinding()]
	param(
		[PoshBot.FromConfig('Domain')]
		[Parameter(DontShow,Mandatory)]
		[string]$Domain,

		[PoshBot.FromConfig('Credential')]
		[Parameter(DontShow,Mandatory)]
		[pscredential]$Credential,

		[Parameter(Position = 0)]
		[Alias('dname')]
		[string]$DomainName


	)

	Connect-MsolService -Credential $Credential

	$Outputvariable = ''
	$UserPrincipalName = ($DomainName -replace '\s','') + $Domain

	if (!($DomainName)) {
		$Outputvariable = Get-MsolUser
	} else {
		$Outputvariable = Get-MsolUser -UserPrincipalName $UserPrincipalName
	}

	foreach ($outputresult in $Outputvariable)
	{
		$r = [pscustomobject]@{
			FirstName = $outputresult.FirstName
			LastName = $outputresult.LastName
			SignInName = $outputresult.SignInName
			Licenses = $outputresult.Licenses.AccountSkuId
			Joined_the_domain = $outputresult.WhenCreated
		}
		$name = $outputresult.DisplayName
		New-PoshBotCardResponse -Title "User:  [$name]" -Text ($r | Format-List -Property * | Out-String)
	}

}
