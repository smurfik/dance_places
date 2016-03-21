class Facebook

  def self.facebook_oauth
    Koala::Facebook::OAuth.new(ENV["APP_ID"], ENV["APP_SECRET"])
  end

  def self.refresh_token
    # Get the new token
    @token ||= facebook_oauth.exchange_access_token_info(ENV["USER_ACCESS_TOKEN"])
  end

  def self.graph
    @graph ||= Koala::Facebook::API.new(ENV["USER_ACCESS_TOKEN"])
  end

end
