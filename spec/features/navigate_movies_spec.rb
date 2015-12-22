describe 'Navigating movies' do
  it 'allows navigation from the detail page to the listing page' do
    movie = Movie.create(movie_attributes)

    visit movie_url(movie)
    click_link 'All Movies' # Capybara provided method to interact with the page

    expect(current_path).to eq(movies_path)
  end

  it 'allows navigation from the listing page tot he detail page' do
    movie = Movie.create(movie_attributes)

    visit movies_url
    click_link movie.title

    expect(current_path).to eq(movie_path(movie))
  end
end
