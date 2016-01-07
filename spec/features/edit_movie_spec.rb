describe 'Editing a movie listing' do

  it "updates the movie and shows the movie's update details" do
    movie = Movie.create(movie_attributes)

    visit movie_url(movie)
    click_link 'Edit'

    expect(current_path).to eq(edit_movie_path(movie))
    expect(find_field('Title').value).to eq(movie.title)

    fill_in 'Title', with: 'Update Movie Title'
    click_button 'Update Movie'

    expect(current_path).to eq(movie_path(movie))
    expect(page).to have_text('Update Movie Title')
    expect(page).to have_text('Movie successfully updated!')
  end

  it 'does not update the movie if it\'s invalid' do
    movie = Movie.create(movie_attributes)

    visit edit_movie_url(movie)
    fill_in 'Title', with: ''
    click_button 'Update Movie'

    expect(page).to have_text('error')
  end
end
