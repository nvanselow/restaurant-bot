require 'spec_helper'

feature "get the restaurants from the yelp api" do
  scenario "make a call to the api" do
    visit '/'
    
    expect(page).to have_content(' ')
  end
end
