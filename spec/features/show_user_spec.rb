describe 'Viewing a user\'s profile page' do
  it 'shows the user\'s details' do
    user = User.crate!(user_attributes)

    visit user_url(user)

    expect(page).to have_text(user.name)
    expect(page).to have_text(user.email)
  end
end
