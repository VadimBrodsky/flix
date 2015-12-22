describe 'Navigating movies' do
  it 'allows navigation from the detail page to the listing page' do
    movie = Movie.create(
      title: 'Iron Man',
      rating: 'PG-13',
      total_gross: 318_412_101.00,
      description: 'Tony Stark builds an armored suit to fight the throes of evil',
      released_on: '2008-05-02')

    visit movie_url(movie)
    click_link 'All Movies' # Capybara provided method to interact with the page

    expect(current_path).to eq(movies_path)
  end

  it 'allows navigation from the listing page tot he detail page' do
    movie = Movie.create(
      title: 'Iron Man',
      rating: 'PG-13',
      total_gross: 318_412_101.00,
      description: 'Tony Stark builds an armored suit to fight the throes of evil',
      released_on: '2008-05-02')

    visit movies_url
    click_link movie.title

    expect(current_path).to eq(movie_path(movie))
  end
end
