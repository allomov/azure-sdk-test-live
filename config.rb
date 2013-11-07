require 'rubygems'
require 'bundler'
Bundler.setup(:default)

require "azure"
require "settingslogic"

class AzureConfig < Settingslogic
  source "./config/azure.yml"
  namespace "azure"
end

Azure.configure do |config|
    # Configure these 2 properties to use Storage
    config.storage_account_name = AzureConfig.storage.account
    config.storage_access_key   = AzureConfig.storage.access_key
    # Configure these 3 properties to use Service Bus
    config.sb_namespace         = AzureConfig.servicebus.namespace
    config.sb_access_key        = AzureConfig.servicebus.access_key
    config.sb_issuer            = AzureConfig.servicebus.issuer
    # Configure these 3 properties to use Service Management
    config.management_certificate = AzureConfig.management_certificate
    config.subscription_id        = AzureConfig.subscription_id
    config.management_endpoint    = AzureConfig.management_endpoint
end
