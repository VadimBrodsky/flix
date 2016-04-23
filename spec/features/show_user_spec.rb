describe 'Viewing a user\'s profile page' do
  it 'shows the user\'s details' do
    user = User.create!(user_attributes)

    sign_in(user)
    visit user_url(user)

    expect(page).to have_text(user.name)
    expect(page).to have_text(user.email)
  end

  it 'shows the user\'s member since date' do
    user = User.create!(user_attributes)

    sign_in(user)
    visit user_url(user)

    expect(page).to have_text("Member Since #{Time.now.strftime('%B %Y')}")
  end

  it 'shows the user\'s favorites in the sidebar' do
    user = User.create!(user_attributes)

    movie = Movie.create!(movie_attributes)
    user.favourite_movies << movie

    sign_in(user)
    visit user_url(user)

    within('aside#sidebar') do
      expect(page).to have_text(movie.title)
    end
  end

  it 'includes the user\'s name in the page title' do
    user = User.create!(user_attributes)

    sign_in(user)
    visit user_url(user)

    expect(page).to have_title("Flix - #{user.name}")
  end
end
