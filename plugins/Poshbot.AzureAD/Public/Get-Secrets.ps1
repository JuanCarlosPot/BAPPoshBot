function Get-Secrets {
	<#
  .SYNOPSIS
      Displays the secret sauce
  .EXAMPLE
      !Get-secrets
  #>
	[PoshBot.BotCommand(Permissions = ('secret'), HideFromHelp = $true)]
	[CmdletBinding()]
	param(
			[parameter(ValueFromRemainingArguments = $true)]
			[object[]]$Arguments
	)

	New-PoshBotCardResponse -ImageUrl "https://i.pinimg.com/564x/65/d1/cf/65d1cf8afbdda3f35989b82b3e56e89b.jpg"
}
