output "azmonitor_out" {
  value = { for k, v in module.AzureMonitor : k => v }
  # value = module.AzureMonitor
}

output "law_out" {
  value = { for k, v in module.AzureMonitor : k => v.law_out }
  # value = module.AzureMonitor.law_out
}

output "sa_out" {
  value = { for k, v in module.AzureMonitor : k => v.sa_out }
  # value = module.AzureMonitor.sa_out
}

output "ehnamespace_out" {
  value = { for k, v in module.AzureMonitor : k => v.ehnamespace_out }
  # value = module.AzureMonitor.ehnamespace_out
}

output "eh_out" {
  value = { for k, v in module.AzureMonitor : k => v.eh_out }
  # value = module.AzureMonitor.eh_out
}
