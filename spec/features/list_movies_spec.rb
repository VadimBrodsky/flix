describe 'Viewing the list of movies' do

  it 'shows the movies' do
    # Arrange
    movie1 = Movie.create(movie_attributes(title: 'movie a', total_gross: 318_412_101.00))
    movie2 = Movie.create(movie_attributes(title: 'movie b'))
    movie3 = Movie.create(movie_attributes(title: 'movie c'))

    # Act
    visit movies_url

    # Assert
    expect(page).to have_text('3 Movies')
    expect(page).to have_text(movie1.title)
    expect(page).to have_text(movie2.title)
    expect(page).to have_text(movie3.title)

    expect(page).to have_text(movie1.released_on.year)
    expect(page).to have_text(movie1.description[0..9])
    expect(page).to have_text('$318,412,101.00')
  end

  it 'does not show a movie that was not yet released' do
    movie = Movie.create(movie_attributes(released_on: 1.month.from_now))

    visit movies_path

    expect(page).not_to have_text(movie.title)
  end
end
