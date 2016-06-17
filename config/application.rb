if ENV['RACK_ENV'] != 'production'
  require 'dotenv'
  Dotenv.load
end

require 'yelp'

configure :development, :test do
  require 'pry'
end

configure do
  set :views, 'app/views'
end

Dir[File.join(File.dirname(__FILE__), 'app', '**', '*.rb')].each do |file|
  require file
  also_reload file
end
