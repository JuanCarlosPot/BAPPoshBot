@{
  'Poshbot.AzureAD' = @{
    '0.1.0' = @{
      Version = '0.1.0'
      Name = 'Poshbot.AzureAD'
      AdhocPermissions = @()
      ManifestPath = 'C:\Bot Frameworks\poshbot\plugins\Poshbot.AzureAD\Poshbot.AzureAD.psd1'
      CommandPermissions = @{
        'Check-ADLicenses' = @()
        'Add-NewUserAD' = @()
        'Remove-UserAD' = @()
        'Disable-UserAD' = @()
      }
      Enabled = $True
    }
  }
}
