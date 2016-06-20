class YelpApiFake
  @@return_nil = false

  def self.get_businesses_near(address)
    if(@@return_nil == true)
      return []
    end

    [
      OpenStruct.new(
        name: "Some business",
        url: "https://yelp.com/business-page",
        rating: "4.5",
        rating_img_url_small: "some_image.png",
        review_count: "1234",
        location: OpenStruct.new(
          address: ["123 Street"],
          city: "Boston",
          state_code: "MA",
          postal_code: "12345"
        )
      )
    ]
  end
end
