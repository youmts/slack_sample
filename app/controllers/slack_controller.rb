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

    query = "from:@#{user_id} on:2019-11-25"
    debug_messages << query
    search_result = client.search_all(query: query)
    debug_messages << search_result.messages.matches.map { |x| [x.user, x.text, to_tz(x.ts)] }

    query = "on:2019-11-25"
    debug_messages << query
    search_result = client.search_messages(query: query)
    debug_messages << search_result.messages.matches.map { |x| [x.user, x.text, to_tz(x.ts)] }

    debug_messages << "team.accessLogs"
    access_logs = client.team_accessLogs
    debug_messages << access_logs.logins.map { |x| [x.user_id, x.username, to_tz(x.date_first), to_tz(x.date_last), x.count] }

    session[:debug] = debug_messages.map(&:pretty_inspect).join("\n")

    redirect_to '/'
  end

  def to_tz(ts)
    Time.at(ts.to_f).in_time_zone('Tokyo')
  end
end
