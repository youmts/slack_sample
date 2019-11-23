class SlackController < ApplicationController
  def index
    session[:debug] ||= "no slack messages."
    @debug = session[:debug]
  end

  def callback
    info = request.env['omniauth.auth'].info
    access_token = request.env['omniauth.strategy'].access_token

    debug_messages = []

    debug_messages << "token user info:"
    debug_messages << [info.team_name, user_id = info.user_id]

    client = Slack::Web::Client.new(token: access_token.token)

    # channel list
    debug_messages << "conversations.list:"
    conversations = client.conversations_list(types: 'public_channel,private_channel').channels
    debug_messages << conversations.map { |x| x[:name] }

    # search_messages
    debug_messages << "search.all:"

    query = "from:@#{user_id} on:2019-11-24"
    debug_messages << query
    search_result = client.search_all(query: query)
    debug_messages << search_result.messages.matches.map { |x| [x.user, Time.at(x.ts.to_f).in_time_zone] }

    query = "on:2019-11-24"
    debug_messages << query
    search_result = client.search_messages(query: query)
    debug_messages << search_result.messages.matches.map { |x| [x.user, Time.at(x.ts.to_f).in_time_zone] }

    session[:debug] = debug_messages.map(&:pretty_inspect).join("\n")

    redirect_to '/'
  end
end
