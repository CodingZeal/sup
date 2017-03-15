require "slack"

Slack.configure do |config|
  config.token = ENV.fetch('SLACK_AUTH_TOKEN')
end
