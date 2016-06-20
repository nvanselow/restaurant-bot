class YelpApi
  def self.get_businesses_near(address)
    client = Yelp::Client.new({
        consumer_key: ENV['YELP_CONSUMER_KEY'],
        consumer_secret: ENV['YELP_CONSUMER_SECRET'],
        token: ENV['YELP_TOKEN'],
        token_secret: ENV['YELP_TOKEN_SECRET']
      })

    search_params = {
      limit: 20,
      radius_filter: 2000
    }
    response = client.search(address, search_params)
    reject_closed_businesses(response.businesses)
  end

  private

  def self.reject_closed_businesses(businesses)
    businesses.select { |business| !business.is_closed }
  end
end
