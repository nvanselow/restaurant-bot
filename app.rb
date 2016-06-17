require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/flash'
require 'httparty'
require 'uri'
require_relative 'config/application'

get '/' do
  # if(params[:token] != ENV['SLACK_TOKEN'])
  #   return halt 404, "Sorry, this is only for a particular slack channel"
  # end

  response = get_businesses
  open_businesses = response.businesses.select { |business| !business.is_closed }

  if(open_businesses.empty?)
    @message = "Sorry, there are no open restaurants nearby. Try again later."
  else
    business = open_businesses.sample

    @message = rating_in_words(business.rating)
    @message << business.name
    @message << stringify_business_details(business)
  end

  erb :index
end

private

def current_address
  '33 Harrison Ave Boston, MA 02111'
end

def get_businesses
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
  client.search(current_address, search_params)
end

def rating_in_words(rating)
  rating = rating.to_f
  if(rating > 4)
    "This place seems great: "
  elsif(rating > 3 && rating < 4)
    "This place seems ok: "
  else
    "This place might not be so good: "
  end
end

def stringify_business_details(business)
  " (#{business.location.address[0]}, #{business.location.city}, #{business.location.state_code} #{business.location.postal_code})"
end
