describe 'A user' do
  it 'requires a name' do
    user = User.new(user_attributes(name: ''))
    user.valid?
    expect(user.errors[:name].any?).to eq(true)
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
                      password: 'secret',
                      password_confirmation: ''))
    user.valid?
    expect(user.errors[:password].any?).to eq(true)
  end

  it 'requires the password to match the password confirmation' do
    user = User.new(user_attributes(
                      password: 'secret',
                      password_confirmation: 'password'))
    user.valid?
    expect(user.errors[:password].first).to eq('doesn\'t match Password')
  end

  it 'requires a password and matching confirmation when when creating' do
    user = User.new(user_attributes(
                      password: 'secret',
                      password_confirmation: 'secret'))
    expect(user.valid?).to eq(true)
  end

  it 'does not require a password when updating' do
    user = User.create!(user_attributes)
    user.password = 'new password'
    expect(user.valid?).to eq(true)
  end

  it 'automatically encrypts the password into the password_digest attribute' do
    user = User.new(user_attributes(password: 'secret'))
    expect(user.password_digest.present?).to eq(true)
  end
end
