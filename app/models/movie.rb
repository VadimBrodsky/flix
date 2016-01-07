class Movie < ActiveRecord::Base

  RATINGS = %w(G PG PG-13 R NC-17)

  validates :title, :released_on, :duration, presence: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validates :image_file_name, allow_blank: true, format:
    {
      with: /\w+\.(gif|jpg|png)\z/i,
      message: 'must reference a GIF, JPG, or PNG image'
    }
  validates :rating, inclusion: { in: RATINGS }

  has_many :reviews

  def flop?
    total_gross.blank? || total_gross < 50_000_000
  end

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
    where('total_gross < ?', 50_000_000).order(total_gross: :asc)
  end

  def self.recently_added
    order(created_at: :desc).limit(3)
  end
end
