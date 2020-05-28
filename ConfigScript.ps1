# Install PoshBot and additional modules
if (Get-Module -ListAvailable -Name PoshBot) {
    Write-Host "Poshbot Module already installed"
} 
else {
	Write-Host "Installing PoshBot Module"
    Install-Module PoshBot -Force -AllowClobber
}

if (Get-Module -ListAvailable -Name AzureAD) {
    Write-Host "AzureAD Module already installed"
} 
else {
	Write-Host "Installing AzureAD Module"
    Install-Module AzureAD -Force -AllowClobber
}

if (Get-Module -ListAvailable -Name MSOnline) {
    Write-Host "MSOnline Module already installed"
} 
else {
	Write-Host "Installing MSOnline Module"
    Install-Module MSOnline -Force -AllowClobber
}


# Define Bot Configuration
$Token = Read-Host -Prompt 'Input your API key' #API token from slack
$BotName = Read-Host -Prompt 'Input your bot name' # The name of the bot created in slack
$BotAdmin = Read-Host -Prompt 'Input your bot administrator account for slack' # My account name in Slack

Write-Output "Input the username and password of the bot admin account on the tenant."
$Credential = $host.ui.PromptForCredential("Need credentials", "Please enter the user name and password of the bot admin account on the tenant.", "", "") #Input the username and password of the bot admin account.

$Domain = Read-Host -Prompt 'Input your Office365 domain'
$PoshbotPath = $PSScriptRoot
$PoshbotConfig = Join-Path $PoshbotPath config.psd1
$PoshbotPlugins = Join-Path $PoshbotPath plugins
$PoshbotLogs = Join-Path $PoshbotPath logs

$BotParams = @{
    Name = $BotName
    BotAdmins = $BotAdmin
    CommandPrefix = '!'
    LogLevel = 'Info'
    BackendConfiguration = @{
        Name = 'SlackBackend'
        Token = $Token
    }
    AlternateCommandPrefixes = 'bender', 'hal'
    ConfigurationDirectory = $PoshbotPath
    LogDirectory = $PoshbotLogs
    PluginDirectory = $PoshbotPlugins
	PluginConfiguration = @{
    'PoshBot.AzureAD' = @{
      Credential = $Credential
      Domain = $Domain
    }
  }
}

mkdir $PoshbotLogs
$pbc = New-PoshBotConfiguration @BotParams
Save-PoshBotConfiguration -InputObject $pbc -Path $PoshbotConfig -Force