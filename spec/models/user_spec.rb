describe 'A user' do
  it 'requires a name'

  it 'requires an email'

  it 'accepts properly formatted email addresses'

  it 'rejects improperly formatted email addresses'

  it 'requires a unique, case insensitive email address'

  it 'is valid with example attributes'

  it 'requires a password'

  it 'requires a password confirmation when a password is present'

  it 'requires the password to match the password confirmation'

  it 'requires a password and matching confirmation when when creating'

  it 'does not require a password when updating'

  it 'automatically encrypts the password into the password_digest attribute'
end
