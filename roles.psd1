@{
  Admin = @{
    Description = 'Bot administrator role'
    Name = 'Admin'
    Permissions = @('Builtin:show-help','Builtin:manage-schedules','Builtin:view-group','Builtin:manage-plugins','Builtin:manage-roles','Builtin:manage-permissions','Builtin:view','Builtin:view-role','Builtin:manage-groups')
  }
  'domain-admin' = @{
    Description = 'Domain administrator'
    Name = 'domain-admin'
    Permissions = @('Poshbot.AzureAD:domain-admin')
  }
  secret = @{
    Description = 'Secret role'
    Name = 'secret'
    Permissions = @('Poshbot.AzureAD:secret')
  }
}
