#Check for MSOnline module
$Modules = @('MSOnline', 'AzureAD', 'CredentialManager')
Foreach ($modulename in $Modules)
{
  $Module = Get-Module -Name $modulename -ListAvailable

  if($Module.count -eq 0)
  {
   Write-Host $modulename module is not available  -ForegroundColor yellow
   $Confirm= Read-Host Are you sure you want to install module? [Y] Yes [N] No
   if($Confirm -match "[yY]")
   {
    Install-Module $modulename
    Import-Module $modulename
   }
   else
   {
    Write-Host $modulename module is required to use PoshBot.AzureAD functions. Please install module using Install-Module $modulename cmdlet.
    Exit
   }
  }
}
