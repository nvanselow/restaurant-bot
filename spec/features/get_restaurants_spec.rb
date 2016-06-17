require 'spec_helper'

feature "get the restaurants from the yelp api" do
  scenario "json response with a random restaurant" do
    business = instance_double("Business",
      name: "Some Restaurant",
      url: "https://yelp.com/business-page",
      rating_in_words: "This seems like a good place: ",
      location: "1235 Address Road, Boston, MA",
      attachments: ['image', 'another image']
    )
    allow(Business).to receive(:get_random_business).and_return(business)

    visit '/'

    expect(page.html).to have_content(business.location)
  end

  scenario "no bussiness is returned from yelp" do
    allow(Business).to receive(:get_random_business).and_return(nil)

    visit '/'

    expect(page.html).to have_content("Sorry, there are no open restaurants nearby")
  end
end
