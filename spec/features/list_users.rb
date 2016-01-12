describe 'Viewing the list of users' do
  it 'shows the users do' do
    user1 = User.create!(user_attributes(name: 'Larry', email: 'larry@example.com'))
    user2 = User.create!(user_attributes(name: 'Moe', email: 'moe@example.com'))
    user3 = User.create!(user_attributes(name: 'Curly', email: 'curly@example.com'))

    visit users_url

    expect(page).to have_text(user1.name)
    expect(page).to have_text(user2.name)
    expect(page).to have_text(user3.name)
  end
end
