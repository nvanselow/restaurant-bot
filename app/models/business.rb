require_relative 'yelp_api'

class Business
  @@yelp_api = YelpApi
  attr_reader :name, :url, :rating, :rating_image, :review_count

  def initialize(yelp_business)
    @name = yelp_business.name
    @address = yelp_business.location.address[0]
    @city = yelp_business.location.city
    @state = yelp_business.location.state_code
    @zip = yelp_business.location.postal_code
    @url = yelp_business.url
    @rating = yelp_business.rating.to_f
    @rating_image = yelp_business.rating_img_url_small
    @review_count = yelp_business.review_count
  end

  def location
    location = "(#{@address}, "
    location << "#{@city}, "
    location << "#{@state} #{@zip})"
    location
  end

  def attachments
    [
      {
        fallback: "The Yelp logo",
        title: "Yelp Logo",
        image_url: "https://obscure-eyrie-21980.herokuapp.com/images/yelp.png"
      },
      {
        fallback: "Ratings",
        title: "#{@review_count} ratings",
        image_url: @rating_image
      }
    ]
  end

  def rating_in_words
    if(rating >= 4)
      "This place seems great: "
    elsif(rating.between?(3, 4))
      "This place seems ok: "
    else
      "This place might not be so good: "
    end
  end

  def self.get_random_business
    businesses = @@yelp_api.get_businesses_near(current_address)
    if(businesses.empty?)
      nil
    else
      Business.new(businesses.sample)
    end
  end

  private

  def self.current_address
    ENV['ADDRESS']
  end

end
