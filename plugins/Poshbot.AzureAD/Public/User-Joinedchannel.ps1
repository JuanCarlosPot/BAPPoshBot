function User-Joinedchannel {
    <#
    .SYNOPSIS
        Responds to a member joining the channel
    #>
    [PoshBot.BotCommand(
        Command = $false,
        TriggerType = 'event',
        MessageType = 'Message',
        MessageSubType = 'ChannelJoined',
				HideFromHelp = $true
    )]
    [cmdletbinding()]
    param(
			[parameter(ValueFromRemainingArguments = $true)]
			[object[]]$Arguments
    )

    Write-Output 'Welcome our new friend :)'
}
