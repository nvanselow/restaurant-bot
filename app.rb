require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/flash'
require 'httparty'
require 'uri'
require_relative 'config/application'

get '/' do
  # binding.pry
  client = Yelp::Client.new({
      consumer_key: ENV['YELP_CONSUMER_KEY'],
      consumer_secret: ENV['YELP_CONSUMER_SECRET'],
      token: ENV['YELP_TOKEN'],
      token_secret: ENV['YELP_TOKEN_SECRET']
    })

  search_params = {
    limit: 10,
    radius_filter: 2000
  }
  # binding.pry
  response = client.search('33 Harrison Ave Boston, MA 02111', search_params)
  # https://api.yelp.com/v2/search/?location=33 Harrison Ave, Boston, MA&limit=10&radius_filter=1500
  # response = HTTParty.post(create_yelp_query, build_body)
  @business = responses.businesses.sample

  erb :index
end

private

def current_address
  '33 Harrison Ave Boston, MA 02111'
end

def create_yelp_query
  URI.escape("https://api.yelp.com/v2/search/?location=33 Harrison Ave Boston MA&limit=10&radius_filter=1500")
end

def build_body
  {
    body: {
      oauth_consumer_key: ENV['YELP_CONSUMER_KEY'],
      oauth_token: ENV['YELP_TOKEN'],
      oauth_signature_method: 'hmac-sha1',
      oauth_signature: ENV['YELP_TOKEN_SECRET'],
      # consumer_secret: ENV['YELP_CONSUMER_SECRET'],
      oauth_timestamp: Time.now.to_i,
      oauth_nonce: SecureRandom.base64
    }
  }
end
