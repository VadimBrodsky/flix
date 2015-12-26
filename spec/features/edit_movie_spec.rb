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
  end

end
