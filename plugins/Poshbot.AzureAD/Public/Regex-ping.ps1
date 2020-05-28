function Regex-ping {
	<#
  .SYNOPSIS
      Responds to ping
  #>
	[PoshBot.BotCommand(
        Command = $false,
        CommandName = 'ping',
        TriggerType = 'regex',
        Regex = '\b(ping)\b',
				HideFromHelp = $true
	)]
	[CmdletBinding()]
	param(
			[parameter(ValueFromRemainingArguments)]
			$Dummy
    )

    Write-Output 'Pong!'

}
