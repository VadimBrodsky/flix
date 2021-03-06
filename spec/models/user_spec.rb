describe 'A user' do
  it 'requires a name' do
    user = User.new(user_attributes(name: ''))
    user.valid?
    expect(user.errors[:name].any?).to eq(true)
  end

  it 'requires a user name' do
    user = User.new(user_attributes(username: ''))
    user.valid?
    expect(user.errors[:name].any?).to eq(false)
  end

  it 'accepts properly formatted user names' do
    usernames = %w(user21 SUPERMAN 1LLya)
    usernames.each do |username|
      user = User.new(user_attributes(username: username))
      user.valid?
      expect(user.errors[:username].any?).to eq(false)
    end
  end

  it 'rejects improperly formatted user names' do
    usernames = %w(US*&ER C@Rss)
    usernames.each do |username|
      user = User.new(user_attributes(username: username))
      user.valid?
      expect(user.errors[:username].any?).to eq(true)
    end
  end

  it 'rejects a user name that is already taken' do
    User.create!(user_attributes(username: 'superman'))
    user2 = User.new(user_attributes(username: 'Superman'))
    user2.valid?
    expect(user2.errors[:username].any?).to eq(true)
  end

  it 'requires an email' do
    user = User.new(user_attributes(email: ''))
    user.valid?
    expect(user.errors[:email].any?).to eq(true)
  end

  it 'accepts properly formatted email addresses' do
    emails = %w(user@example.com first.last@example.org)
    emails.each do |email|
      user = User.new(user_attributes(email: email))
      user.valid?
      expect(user.errors[:email].any?).to eq(false)
    end
  end

  it 'rejects improperly formatted email addresses' do
    emails = %w(@ user@ @example.com emailataddress.com emaail@@addresss.what?)
    emails.each do |email|
      user = User.new(user_attributes(email: email))
      user.valid?
      expect(user.errors[:email].any?).to eq(true)
    end
  end

  it 'requires a unique, case insensitive email address' do
    User.create!(user_attributes(email: 'name@example.com'))
    user2 = User.new(user_attributes(email: 'NAME@EXAMPLE.com'))
    user2.valid?
    expect(user2.errors[:email].first).to eq('has already been taken')
  end

  it 'is valid with example attributes' do
    user = User.new(user_attributes)
    expect(user.valid?).to eq(true)
  end

  it 'requires a password' do
    user = User.new(user_attributes(password: ''))
    user.valid?
    expect(user.errors[:password].any?).to eq(true)
  end

  it 'requires a password confirmation when a password is present' do
    user = User.new(user_attributes(
                      password: 'abracadabra',
                      password_confirmation: ''))
    user.valid?
    expect(user.errors[:password_confirmation].any?).to eq(true)
  end

  it 'requires the password to match the password confirmation' do
    user = User.new(user_attributes(
                      password: 'abracadabra',
                      password_confirmation: 'cadabrabra'))
    user.valid?
    expect(user.errors[:password_confirmation].first).to eq('doesn\'t match Password')
  end

  it 'requires a password and matching confirmation when when creating' do
    user = User.new(user_attributes(
                      password: 'abracadabra',
                      password_confirmation: 'abracadabra'))
    expect(user.valid?).to eq(true)
  end

  it 'does not require a password when updating' do
    user = User.create!(user_attributes)
    user.password = ''
    expect(user.valid?).to eq(true)
  end

  it 'automatically encrypts the password into the password_digest attribute' do
    user = User.new(user_attributes(password: 'secret'))
    expect(user.password_digest.present?).to eq(true)
  end

  it 'requires a password with length of 10 characters' do
    user = User.new(user_attributes(password: 'short'))
    user.valid?
    expect(user.errors[:password].any?).to eq(true)
  end
end

describe 'authenticate' do
  before do
    @user = User.create!(user_attributes)
  end

  it 'returns non-true value if the email address does not match' do
    expect(User.authenticate('no match', @user.password)).not_to eq(true)
  end

  it 'returns non-true value if the email password does not match' do
    expect(User.authenticate(@user.email, 'no match')).not_to eq(true)
  end

  it 'returns the user if the email and password match' do
    expect(User.authenticate(@user.email, @user.password)).to eq(@user)
  end

  it 'returns the user if the username and password match' do
    expect(User.authenticate(@user.username, @user.password)).to eq(@user)
  end

  it 'has reviews' do
    movie1 = Movie.new(movie_attributes(title: 'Iron Man'))
    movie2 = Movie.new(movie_attributes(title: 'Superman'))

    review1 = movie1.reviews.new(stars: 5, comment: 'Two thumbs up!')
    review1.user = @user
    review1.save!

    review2 = movie2.reviews.new(stars: 3, comment: 'Cool')
    review2.user = @user
    review2.save!

    expect(@user.reviews).to include(review1)
    expect(@user.reviews).to include(review2)
  end

  it 'has favourite movies' do
    user = User.new(user_attributes)
    movie1 = Movie.new(movie_attributes(title: 'Iron Man'))
    movie2 = Movie.new(movie_attributes(title: 'Superman'))

    user.favorites.new(movie: movie1)
    user.favorites.new(movie: movie2)

    expect(user.favorite_movies).to include(movie1)
    expect(user.favorite_movies).to include(movie2)
  end
end
