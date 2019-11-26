module SlackHelper
  def to_tz(ts)
    Time.at(ts.to_f).in_time_zone('Tokyo')
  end
end
