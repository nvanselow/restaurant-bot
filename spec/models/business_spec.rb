require 'spec_helper'

#fake class to deal with method chaining for Business double
# Possible use struct instead?
# class Location
#   attr_reader :address, :city, :state_code, :postal_code
# end

describe Business do
#   let(:location){ instance_double("Location",
#     address: ["123 Street"],
#     city: "Boston",
#     state_code: "MA",
#     postal_code: "12345"
#   )}
  let(:yelp_business) { YelpApiFake.get_businesses_near("na")[0] }
  ## Use Factorygirl instead?

  before do
    Business.class_variable_set(:@@yelp_api, YelpApiFake)
  end

  describe ".get_random_business" do
    it "gets a random business form the yelp api" do
      # allow(Business).to receive(:get_businesses).and_return([yelp_business])

      new_business = Business.get_random_business

      expect(new_business).to be_a(Business)
      expect(new_business.name).to eq(yelp_business.name)
    end

    it "returns nil if no businesses are available" do
      # allow(Business).to receive(:get_businesses).and_return([])
      YelpApiFake.class_variable_set(:@@return_nil, true)

      expect(Business.get_random_business).to eq(nil)

      YelpApiFake.class_variable_set(:@@return_nil, false)
    end
  end

  describe ".new" do
    it "creates a new instance of a Business from yelp information" do
      expect(Business.new(yelp_business)).to be_a(Business)
    end
  end

  let(:new_business) { Business.new(yelp_business) }

  describe "#location" do
    it "returns a string with the full address of a business" do
      expect(new_business.location).to eq("(#{yelp_business.location.address[0]}, #{yelp_business.location.city}, #{yelp_business.location.state_code} #{yelp_business.location.postal_code})")
    end
  end

  describe "#attachments" do
    it "returns an array of image attachments for slack" do
      expect(new_business.attachments).to eq([
        {
          fallback: "The Yelp logo",
          title: "Yelp Logo",
          image_url: "https://obscure-eyrie-21980.herokuapp.com/images/yelp.png"
        },
        {
          fallback: "Ratings",
          title: "#{new_business.review_count} ratings",
          image_url: new_business.rating_image
        }
      ])
    end
  end

  describe "#rating_in_words" do
    it "returns a very positive statement for high reviews" do
      allow(new_business).to receive(:rating).and_return(5)

      expect(new_business.rating_in_words).to include("This place seems great")
    end

    it "returns an ok statement for moderate reviews" do
      allow(new_business).to receive(:rating).and_return(3.5)

      expect(new_business.rating_in_words).to include("This place seems ok")
    end

    it "returns a hesitant statement for poor reviews" do
      allow(new_business).to receive(:rating).and_return(2)

      expect(new_business.rating_in_words).to include("This place might not be so good")
    end
  end

end
