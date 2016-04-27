describe 'Viewing a movie listing' do
  it 'shows the movie details' do
    movie1 = Movie.create(movie_attributes(total_gross: 300_000_000.00))

    visit movie_url(movie1)

    expect(page).to have_text(movie1.title)
    expect(page).to have_text(movie1.rating)
    expect(page).to have_text(movie1.description)
    expect(page).to have_text(movie1.released_on)

    expect(page).to have_text(movie1.cast)
    expect(page).to have_text(movie1.director)
    expect(page).to have_text(movie1.duration)
    expect(page).to have_selector("img[src*='#{movie1.image_file_name.split('.').first}']")
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

  it 'it shows the movie\'s fans and genres in the sidebar' do
    movie = Movie.create!(movie_attributes)
    user = User.create!(user_attributes)

    movie.fans << user

    genre = Genre.create!(name: 'Action')
    movie.genres << genre

    visit movie_url(movie)

    within('aside#sidebar') do
      expect(page).to have_text(user.username)
      expect(page).to have_text(genre.name)
    end
  end

  it 'includes the movie\'s title in the page title' do
    movie = Movie.create!(movie_attributes)

    visit movie_url(movie)

    expect(page).to have_title("#{movie.title}")
  end

  it 'has an SEO-friendly URL' do
    movie = Movie.create!(movie_attributes(title: 'X-Men: The Last Stand'))

    visit movie_url(movie)

    expect(current_path).to eq('/movies/x-men-the-last-stand')
  end
end
