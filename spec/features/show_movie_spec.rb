describe 'Viewing a movie listing' do
  it 'shows the movie details' do
    movie1 = Movie.create(movie_attributes(total_gross: 300_000_000.00))

    visit movie_url(movie1)

    expect(page).to have_text(movie1.title)
    expect(page).to have_text(movie1.rating)
    expect(page).to have_text(movie1.description)
    expect(page).to have_text(movie1.released_on)

    expect(page).to have_text(movie.cast)
    expect(page).to have_text(movie.director)
    expect(page).to have_text(movie.duration)
    expect(page).to have_selector("img[src$='#{movie.image_file_name}']")
  end

  it 'shows the total gross if the total gross exceeds $50M' do
    movie = Movie.create(movie_attributes(total_gross: 600_000_000.00))
    visit movie_url(movie)

    expect(page).to have_text('$600,000,000.00')
  end

  it "shows 'Flop!' if the total gross is less than $50M" do
    movie = Movie.create(movie_attributes(total_gross: 20_000_000.00))
    visit movie_url(movie)

    expect(page).to have_text('Flop!')
  end
end
