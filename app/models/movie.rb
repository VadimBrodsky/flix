class Movie < ActiveRecord::Base

  RATINGS = %w(G PG PG-13 R NC-17)
  FLOP_AMOUNT = 50_000_000
  HIT_AMOUNT = 300_000_000

  validates :title, :released_on, :duration, presence: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validates :image_file_name, allow_blank: true, format:
    {
      with: /\w+\.(gif|jpg|png)\z/i,
      message: 'must reference a GIF, JPG, or PNG image'
    }
  validates :rating, inclusion: { in: RATINGS }

  has_many :reviews, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user
  has_many :critics, through: :reviews, source: :user
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations

  scope :released, -> { where('released_on <= ?', Time.now).order(released_on: :desc) }
  scope :hits, -> { released.where('total_gross >= ?', HIT_AMOUNT).order(total_gross: :desc) }
  scope :flops, -> { released.where('total_gross < ?', FLOP_AMOUNT).order(total_gross: :asc) }
  scope :recently_added, -> { order(created_at: :desc).limit(3) }
  scope :upcoming, -> { where('released_on > ?', Time.now).order(released_on: :asc) }
  scope :rated, -> (rating) { released.where(rating: rating)}
  scope :recent, -> (max=5) { released.limit(max) }
  scope :grossed_less_than, -> (max) { released.where('total_gross < ?', max) }
  scope :grossed_greater_than, -> (min) { released.where('total_gross > ?', min) }

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

  def to_param
    "#{id}-#{title.parameterize}"
  end
end
