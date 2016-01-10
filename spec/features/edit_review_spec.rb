describe 'Editing a movie review' do
  it 'updates the review and shows the movie\'s review listing' do
    movie = Movie.create(movie_attributes)
    review = movie.reviews.create(review_attributes(name: 'old name'))

    visit movie_reviews_url(movie)
    within(".review-#{review.id}") do
      click_link('Edit')
    end

    expect(current_path).to eq(edit_movie_review_path(movie, review))

    fill_in 'Name', with: 'new name'
    click_button 'Update Review'

    expect(current_path).to eq(movie_reviews_url(movie))
    expect(page).to have_text('new name')
    expect(page).not_to have_text('old name')
    expect(page).to have_text('Review successfully updated!')
  end

  it 'does not update the review if it\'s invalid' do
    movie = Movie.create(movie_attributes)
    review = movie.reviews.create(review_attributes)

    visit edit_movie_review_path(movie, review)
    fill_in 'Name', with: ''
    click_button 'Update Review'

    expect(current_path).to eq(edit_movie_reviews_path(movie, review))
    expect(page).to have_text('error')
  end
end
