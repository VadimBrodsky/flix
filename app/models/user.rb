class User < ActiveRecord::Base
  has_secure_password

  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_movies, through: :favorites, source: :movie

  validates :name, presence: true
  validates :email, presence: true,
                    format: /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i,
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 10, allow_blank: true }
  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       format: /\A[a-z0-9]+\z/i

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

  def self.authenticate(email_or_username, password)
    user = User.find_by(email: email_or_username) ||
           User.find_by(username: email_or_username)
    user && user.authenticate(password)
  end
end
