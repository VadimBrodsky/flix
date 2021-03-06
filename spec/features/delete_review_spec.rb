describe 'Deleting a review' do
  before do
    @user = User.create!(user_attributes)
    sign_in(@user)
  end

  it 'destroys the review and shows the review listing without the deleted review' do
    movie = Movie.create!(movie_attributes)
    movie.reviews.create!(review_attributes(comment: 'Delete me review', user: @user))
    movie.reviews.create!(review_attributes(user: @user))

    visit movie_reviews_path(movie)
    within('.review-1') do
      click_link('Delete')
    end

    expect(page).not_to have_text('Delete me review')
    expect(page).to have_text('Review deleted successfully!')
  end
end
