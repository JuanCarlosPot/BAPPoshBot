function Check-ADLicenses {
	<#
  .SYNOPSIS
      Displays all the active licenses on the domain
  .EXAMPLE
      !Check-ADLicenses
  #>
	[PoshBot.BotCommand(
        Permissions = ('domain-admin'),
        Aliases = ('check-licenses', 'licenses')
	)]
	[CmdletBinding()]
	param(
		[PoshBot.FromConfig('Credential')]
		[Parameter(DontShow,Mandatory)]
		[pscredential]$Credential
	)

	Connect-MsolService -Credential $Credential

	$Result = ""
	$Results = @()

	#FriendlyName list for license plan
	$FriendlyNameHash = @()
	$FriendlyNameHash = Get-Content -Raw -Path 'C:\Bot Frameworks\poshbot\notes\LicenseFriendlyName.txt' -ErrorAction Stop | ConvertFrom-StringData

	$Subscriptions = Get-MsolSubscription | ForEach-Object {
		$SubscriptionName = $_.SKUPartNumber
		$SubscribedOn = $_.DateCreated
		$ExpiryDate = $_.NextLifeCycleDate
		$Status = $_.Status
		$TotalLicenses = $_.TotalLicenses

		#Convert Skuid to friendly name
		$EasyName = $FriendlyNameHash[$SubscriptionName]
		$EasyName
		if (!($EasyName))
		{
			$NamePrint = $SubscriptionName
		}
		else
		{
			$NamePrint = $EasyName
		}

		#Determine subscription type
		if ($_.IsTrial -eq $False)
		{
			if (($SubscriptionName -like "*Free*") -or ($ExpiryDate -eq $null))
			{
				$SubscriptionType = "Free"
			}
			else
			{
				$SubscriptionType = "Purchased"
			}
		}
		else
		{
			$SubscriptionType = "Trial"
		}

		#Friendly Expiry Date
		if ($ExpiryDate -ne $null)
		{
			$FriendlyExpiryDate = (New-TimeSpan -Start (Get-Date) -End $ExpiryDate).Days
			if ($Status -eq "Enabled")
			{
				$FriendlyExpiryDate = "Will expire in $FriendlyExpiryDate days"
			}
			elseif ($Status -eq "Warning")
			{
				$FriendlyExpiryDate = "Expired.Will suspend in $FriendlyExpiryDate days"
			}
			elseif ($Status -eq "Suspended")
			{
				$FriendlyExpiryDate = "Expired.Will delete in $FriendlyExpiryDate days"
			}
			elseif ($Status -eq "LockedOut")
			{
				$FriendlyExpiryDate = "Subscription is locked.Please contact Microsoft"
			}
		}
		else
		{
			$ExpiryDate = "-"
			$FriendlyExpiryDate = "Never Expires"
		}

		$Result = [ordered]@{ 'Friendly Subscription Name' = $NamePrint; 'Subscription Name' = $SubscriptionName; 'Subscribed Date' = $Subscribedon; 'License Expiry Date' = $ExpiryDate; 'Friendly Expiry Date' = $FriendlyExpiryDate; 'Subscription Type' = $SubscriptionType; 'Total Licenses' = $TotalLicenses; 'Status' = $Status }
		$Results = New-Object PSObject -Property $Result
	}

	foreach ($outputresult in $Results)
	{

		New-PoshBotCardResponse -Text ($outputresult | Format-List -Property * | Out-String)
	}

}
