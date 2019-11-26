class SlackController < ApplicationController
  def index
    if session[:slack_user_token]
      client = Slack::Web::Client.new(token: session[:slack_user_token])

      debug_messages = []

      # channel list
      debug_messages << "conversations.list:"
      conversations = client.conversations_list(types: 'public_channel,private_channel').channels
      debug_messages << conversations.map { |x| x[:name] }

      # search_messages

      query = "from:@UQAQ91PQB on:2019-11-25"
      debug_messages << "user_messages_query: #{query}"
      search_result = client.search_all(query: query)
      @user_messages = search_result.messages.matches

      query = "on:2019-11-25"
      debug_messages << "all_messages_query: #{query}"
      search_result = client.search_messages(query: query)
      @all_messages = search_result.messages.matches

      @debug = debug_messages.map(&:pretty_inspect).join("\n")
    else
      @debug = 'no slack user token.'
    end

    if session[:slack_admin_token]
      client = Slack::Web::Client.new(token: session[:slack_admin_token])

      debug_messages = []

      @access_logs = client.team_accessLogs.logins

      @debug_admin = debug_messages.map(&:pretty_inspect).join("\n")
    else
      @debug_admin = 'no slack admin token.'
    end
  end

  def user_callback
    info = request.env['omniauth.auth'].info
    access_token = request.env['omniauth.strategy'].access_token

    session[:slack_user_token] = access_token.token

    redirect_to '/'
  end

  def admin_callback
    info = request.env['omniauth.auth'].info
    access_token = request.env['omniauth.strategy'].access_token

    session[:slack_admin_token] = access_token.token

    redirect_to '/'
  end

  def to_tz(ts)
    Time.at(ts.to_f).in_time_zone('Tokyo')
  end
end
