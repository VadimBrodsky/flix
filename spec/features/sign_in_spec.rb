describe 'Signing in' do
  it 'prompts for an email and password' do
    visit root_url
    click_link 'Sign In'
    expect(current_path).to eq(new_session_path)
    expect(page).to have_field('Email')
    expect(page).to have_field('Password')
  end
end
