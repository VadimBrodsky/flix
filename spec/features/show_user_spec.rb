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
end
