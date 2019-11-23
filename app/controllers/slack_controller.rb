class SlackController < ApplicationController
  def index
  end

  def callback
    info = request.env['omniauth.auth'].info
    access_token = request.env['omniauth.strategy'].access_token

    pp info.team_name, user_id = info.user_id

    client = Slack::Web::Client.new(token: access_token.token)

    # channel list
    conversations = client.conversations_list(types: 'public_channel,private_channel').channels
    pp conversations.map { |x| x[:name] }

    # search_messages
    search_result = client.search_all(query: "from:@#{user_id} on:2019-11-23")
    pp search_result.messages.matches.map { |x| [x.user, Time.at(x.ts.to_f).in_time_zone] }

    search_result = client.search_messages(query: "on:2019-11-23")
    pp search_result.messages.matches.map { |x| [x.user, Time.at(x.ts.to_f).in_time_zone] }

    redirect_to '/'
  end
end
