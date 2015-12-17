require "spec_helper"

describe 'Viewing the list of movies' do
  it 'shows the movies' do
    visit 'http://example.com/movies'
    expect(page).to have_text("3 Movies")
  end
end
