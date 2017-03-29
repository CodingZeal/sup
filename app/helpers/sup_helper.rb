module SupHelper
  def self.create_slack_mpim(meeting)
    mpim_channel = slack_client.mpim_open(
      users: meeting.members.pluck(:slack_id).join(',') + ',' + Member::SUP_BOT_SLACK_ID
    )
    slack_client.chat_postMessage(
      channel: mpim_channel['group']['id'],
      text: "Hello friends! You have been chosen to meet for this week's S'up meeting! Find a time that works between now and Friday, and put a quick 20-min break on the calendar to discuss your current events. :smile:",
      as_user: false
    )
  end

  def self.slack_client
    @slack_client ||= Slack.client
  end
end
