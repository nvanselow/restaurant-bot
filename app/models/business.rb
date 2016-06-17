class Business
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
        fallback: "Ratings",
        title: "#{@review_count} ratings",
        image_url: @rating_image
      },
      {
        fallback: "The Yelp logo",
        title: "Yelp Logo",
        image_url: "https://obscure-eyrie-21980.herokuapp.com/images/yelp.png"
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
    businesses = get_businesses
    if(businesses.empty?)
      nil
    else
      Business.new(businesses.sample)
    end
  end

  private

  def self.get_businesses
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
    response = client.search(current_address, search_params)
    reject_closed_businesses(response.businesses)
  end

  def self.current_address
    ENV['ADDRESS']
  end

  def self.reject_closed_businesses(businesses)
    businesses.select { |business| !business.is_closed }
  end
end
