class Movie < ActiveRecord::Base

  RATINGS = %w(G PG PG-13 R NC-17)
  FLOP_AMOUNT = 50_000_000

  validates :title, :released_on, :duration, presence: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validates :image_file_name, allow_blank: true, format:
    {
      with: /\w+\.(gif|jpg|png)\z/i,
      message: 'must reference a GIF, JPG, or PNG image'
    }
  validates :rating, inclusion: { in: RATINGS }

  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user
  has_many :critics, through: :reviews, source: :user
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations

  def self.released
    # Active Record Queries Examples:
    # Movie.count
    # Movie.all
    # Movie.order('released_on')
    # Movie.order('released_on asc')
    # Movie.order(released_on: :asc)
    # Movie.order(released_on: :desc)
    # Movie.find(2)
    # Movie.find_by(title: 'Iron Man')
    # Movie.where(rating: 'PG-13')
    # Movie.where.not(rating: 'PG-13')
    # Movie.where.not(rating: ['PG', 'PG-13'])
    # Movie.where('total_gross < 50000000')
    # Movie.where('total_gross < ?', 50_000_000)
    # Movie.where('released_on <= ?', Time.now)
    # Movie.where('released_on <= ?', Time.now).count
    # Movie.where('released_on <= ?', Time.now).order('released_on')

    where('released_on <= ?', Time.now).order(released_on: :desc)
  end

  def self.hits
    where('total_gross > ?', 300_000_000).order(total_gross: :desc)
  end

  def self.flops
    where('total_gross < ?', FLOP_AMOUNT).order(total_gross: :asc)
  end

  def self.recently_added
    order(created_at: :desc).limit(3)
  end

  def cult_classic?
    reviews.count > 50 && average_stars >= 4
  end

  def flop?
    if cult_classic?
      false
    else
      total_gross.blank? || total_gross < FLOP_AMOUNT
    end
  end

  def average_stars
    reviews.average(:stars)
  end

  def recent_reviews(n)
    reviews.order(created_at: :desc).limit(n)
  end
end
