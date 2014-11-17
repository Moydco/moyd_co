require 'zendesk_api'

$zendesk_client = ZendeskAPI::Client.new do |config|
  # Mandatory:

  config.url = "https://moydco.zendesk.com/api/v2" # e.g. https://mydesk.zendesk.com/api/v2

  # Basic / Token Authentication
  config.username = "a.zuin@moyd.co"

  # OAuth Authentication
  config.token = "q3hFtTcUJlOqv7D0XKZelooEcRklTUUUO4F9j138"

  # Optional:

  # Retry uses middleware to notify the user
  # when hitting the rate limit, sleep automatically,
  # then retry the request.
  config.retry = true

  # Logger prints to STDERR by default, to e.g. print to stdout:
  require 'logger'
  config.logger = Logger.new(STDOUT)

  # Changes Faraday adapter
  # config.adapter = :patron

  # Merged with the default client options hash
  # config.client_options = { :ssl => false }

  # When getting the error 'hostname does not match the server certificate'
  # use the API at https://yoursubdomain.zendesk.com/api/v2
end