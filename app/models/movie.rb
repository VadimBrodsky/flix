class Movie < ActiveRecord::Base
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
end
