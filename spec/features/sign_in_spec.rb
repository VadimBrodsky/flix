describe 'Signing in' do
  it 'prompts for an email and password' do
    visit root_url
    click_link 'Sign In'
    expect(current_path).to eq(signin_path)
    expect(page).to have_field('Email')
    expect(page).to have_field('Password')
  end

  it 'signs in the user if the email/password combination is valid' do
    user = User.create!(user_attributes)
    visit root_url
    click_link 'Sign In'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign In'

    expect(current_path).to eq(user_path(user))
    expect(page).to have_text("Welcome back, #{user.name}!")
  end

  it 'signs in the user if the username/password combination is valid' do
    user = User.create!(user_attributes)
    visit root_url
    click_link 'Sign In'

    fill_in 'Email', with: user.username
    fill_in 'Password', with: user.password
    click_button 'Sign In'

    expect(current_path).to eq(user_path(user))
    expect(page).to have_text("Welcome back, #{user.name}!")
  end

  it 'does not sign in the user if the email/password combination is invalid' do
    user = User.create!(user_attributes)
    visit root_url
    click_link 'Sign In'

    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'no match'
    click_button 'Sign In'

    expect(current_path).to eq(session_path)
    expect(page).to have_text('Invalid')
  end
end
