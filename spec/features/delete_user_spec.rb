describe 'Deleting a user' do
  before do
    @admin = User.create!(user_attributes(admin: true))
    @user = User.create!(user_attributes(name: 'John Smith',
                                         email: 'user@example.com',
                                         username: 'usr'))
    sign_in(@admin)
  end

  it 'destroys the user and redirects to the home page' do
    visit user_path(@user)
    click_link 'Delete Account'

    expect(current_path).to eq(root_path)
    expect(page).to have_text('Account successfully deleted!')

    visit users_path
    expect(page).not_to have_text(@user.name)
  end

  it 'automatically signs out that user' do
    skip 'Only admin can delete users'
    visit user_path(@user)

    click_link 'Delete Account'

    expect(page).to have_link('Sign In')
    expect(page).not_to have_link('Sign Out')
  end
end
