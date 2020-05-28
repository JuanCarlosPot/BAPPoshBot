function Enable-ADUser {
	<#
  .SYNOPSIS
      Enables an user account on the domain.
  .EXAMPLE
      !Enable-ADUser --DomainName JuanCarlosPot
	.EXAMPLE
		  !Enable-ADUser --dname JuanCarlosPot
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

		[Parameter(Mandatory, Position = 0)]
		[Alias('dname')]
		[string]$DomainName

	)

		Connect-AzureAD -Credential $Credential | Out-null

		$upn = ($DomainName -replace '\s','') + $Domain
		Set-AzureADUser -ObjectID $upn -AccountEnabled $true
		$Outputvariable = Get-AzureADUser -ObjectID $upn

		$r = [pscustomobject]@{
			FirstName = $Outputvariable.GivenName
			LastName = $Outputvariable.SurName
			SignInName = $Outputvariable.UserPrincipalName
			Joined_the_domain = $Outputvariable.extensionproperty.createdDateTime
		}

		$name = $Outputvariable.DisplayName
		New-PoshBotCardResponse -Title "User:  [$name] is enabled" -Text ($r | Format-List -Property * | Out-String)

}
