describe 'Editing a movie review' do
  before do
    @user = User.create!(user_attributes)
    sign_in(@user)
  end

  it 'updates the review and shows the movie\'s review listing' do
    movie = Movie.create!(movie_attributes)
    review = movie.reviews.create!(review_attributes(comment: 'old comment'))
    review.user = @user
    review.save

    visit movie_reviews_url(movie)
    within(".review-#{review.id}") do
      click_link('Edit')
    end

    expect(current_path).to eq(edit_movie_review_path(movie, review))

    fill_in 'Comment', with: 'new comment'
    click_button 'Update Review'

    expect(current_path).to eq(movie_reviews_path(movie))
    expect(page).to have_text('new comment')
    expect(page).not_to have_text('old comment')
    expect(page).to have_text('Review updated successfully!')
  end

  it 'does not update the review if it\'s invalid' do
    movie = Movie.create(movie_attributes)
    review = movie.reviews.create(review_attributes)

    visit edit_movie_review_path(movie, review)
    fill_in 'Comment', with: ''
    click_button 'Update Review'

    expect(current_path).to eq(movie_review_path(movie, review))
    expect(page).to have_text('error')
  end
end
