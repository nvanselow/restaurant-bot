require 'sinatra'
require 'sinatra/reloader'
require 'json'
require_relative 'config/application'
require_relative 'app/models/business'

get '/' do
  # if(params[:token] != ENV['SLACK_TOKEN'])
  #   return halt 404, "Sorry, this is only for a particular slack channel"
  # end
  business = Business.get_random_business

  if(business)
    message = business.rating_in_words
    message << "\n<#{business.url}|#{business.name}>\n"
    message << business.location

    attachments = business.attachments
  else
    message = "Sorry, there are no open restaurants nearby. Try again later."
    attachments = []
  end

  content_type :json
  { text: message, attachments: attachments}.to_json
end
