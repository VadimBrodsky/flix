describe 'A movie' do
  it 'is a flop if the total gross is less than $50M' do
    movie = Movie.new(total_gross: 40_000_000.00)

    expect(movie.flop?).to eq(true)
  end

  it 'is a flop if the total_gross is blank' do
    movie = Movie.new(total_gross: nil)

    expect(movie.flop?).to eq(true)
  end

  it 'is a success if the total gross is greate than $50M' do
    movie = Movie.new(total_gross: 60_000_000.00)

    expect(movie.flop?).to eq(false)
  end

  it 'is released when the released on date is in the past' do
    movie = Movie.create(movie_attributes(released_on: 3.months.ago))

    expect(Movie.released).to include(movie)
  end

  it 'is not released when the released on date is in the future' do
    movie = Movie.create(movie_attributes(released_on: 3.months.from_now))

    expect(Movie.released).not_to include(movie)
  end

  it 'returns movies ordered with the most recently-released movie first' do
    movie1 = Movie.create(movie_attributes(title: 'movie a', released_on: 3.months.ago))
    movie2 = Movie.create(movie_attributes(title: 'movie b', released_on: 2.months.ago))
    movie3 = Movie.create(movie_attributes(title: 'movie c', released_on: 1.months.ago))

    expect(Movie.released).to eq([movie3, movie2, movie1])
  end

  it 'requires a title' do
    movie = Movie.new(title: '')

    movie.valid? # populates errors

    expect(movie.errors[:title].any?).to eq(true)
  end

  it 'requires a description' do
    movie = Movie.new(description: '')

    movie.valid?

    expect(movie.errors[:description].any?).to eq(true)
  end

  it 'requires a released date' do
    movie = Movie.new(released_on: '')

    movie.valid?

    expect(movie.errors[:released_on].any?).to eq(true)
  end

  it 'requires a duration' do
    movie = Movie.new(duration: '')

    movie.valid?

    expect(movie.errors[:duration].any?).to eq(true)
  end

  it 'requires a description over 24 characters' do
    movie = Movie.new(description: 'X' * 24)

    movie.valid?

    expect(movie.errors[:description].any?).to eq(true)
  end

  it 'accepts a $0 total gross' do
    movie = Movie.new(total_gross: 0.00)

    movie.valid?

    expect(movie.errors[:total_gross].any?).to eq(false)
  end

  it 'accepts a positive total gross' do
    movie = Movie.new(total_gross: 100_000_000.00)

    movie.valid?

    expect(movie.errors[:total_gross].any?).to eq(false)
  end

  it 'rejects a negative total gross' do
    movie = Movie.new(total_gross: -100_000_000.00)
    movie.valid?
    expect(movie.errors[:total_gross].any?).to eq(true)
  end

  it 'accepts properly formatted image file names' do
    file_names = %w(e.png movie.png movie.jpg movie.gif MOVIE.GIF)
    file_names.each do |file_name|
      movie = Movie.new(image_file_name: file_name)
      movie.valid?
      expect(movie.errors[:image_file_name].any?).to eq(false)
    end
  end

  it 'rejects improperly formatted image file names' do
    file_names = %w(movie .jpg .png movie.pdf movie.doc)
    file_names.each do |file_name|
      movie = Movie.new(image_file_name: file_name)
      movie.valid?
      expect(movie.errors[:image_file_name].any?).to eq(true)
    end
  end

  it 'accepts any rating that is in an approved list' do
    ratings = %w(G PG PG-13 R NC-17)
    ratings.each do |rating|
      movie = Movie.new(rating: rating)
      movie.valid?
      expect(movie.errors[:rating].any?).to eq(false)
    end
  end

  it 'rejects any rating that is in an approved list' do
    ratings = %w(R-13 R-16 R-18 R-21)
    ratings.each do |rating|
      movie = Movie.new(rating: rating)
      movie.valid?
      expect(movie.errors[:rating].any?).to eq(true)
    end
  end

  it 'is valid with example attributes' do
    movie = Movie.new(movie_attributes)

    expect(movie.valid?).to eq(true)
  end

  it 'has many reviews' do
    movie = Movie.new(movie_attributes)

    review1 = movie.reviews.new(review_attributes)
    review2 = movie.reviews.new(review_attributes)

    expect(movie.reviews).to include(review1)
    expect(movie.reviews).to include(review2)
  end

  it 'deletes associated reviews' do
    movie = Movie.create(movie_attributes)
    movie.reviews.create(review_attributes)
    expect { movie.destroy }.to change(Review, :count).by(-1)
  end

  it 'calculates the average number of review stars' do
    movie = Movie.create(movie_attributes)

    movie.reviews.create(review_attributes(stars: 1))
    movie.reviews.create(review_attributes(stars: 3))
    movie.reviews.create(review_attributes(stars: 5))

    expect(movie.average_stars).to eq(3)
  end

  it 'has fans' do
    movie = Movie.new(movie_attributes)
    fan1 = User.new(user_attributes(email: 'larry@example.com'))
    fan2 = User.new(user_attributes(email: 'moe@example.com'))

    movie.favorites.new(user: fan1)
    movie.favorites.new(user: fan2)

    expect(movie.fans).to include(fan1)
    expect(movie.fans).to include(fan2)
  end

  context 'upcoming query' do
    it 'returns the movies with a released on date in the future' do
      movie1 = Movie.create!(movie_attributes(title: 'movie a', released_on: 3.months.ago))
      movie2 = Movie.create!(movie_attributes(title: 'movie b', released_on: 3.months.from_now))

      expect(Movie.upcoming).to eq([movie2])
    end
  end

  context 'rated query' do
    it 'returns released movies with the specified rating' do
      movie1 = Movie.create!(movie_attributes(title: 'movie a', released_on: 3.months.ago, rating: 'PG'))
      movie2 = Movie.create!(movie_attributes(title: 'movie b', released_on: 3.months.ago, rating: 'PG-13'))
      movie3 = Movie.create!(movie_attributes(title: 'movie c', released_on: 1.month.from_now, rating: 'PG'))

      expect(Movie.rated('PG')).to eq([movie1])
    end
  end

  context 'recent query' do
    before do
      @movie1 = Movie.create!(movie_attributes(title: 'movie a', released_on: 3.months.ago))
      @movie2 = Movie.create!(movie_attributes(title: 'movie b', released_on: 2.months.ago))
      @movie3 = Movie.create!(movie_attributes(title: 'movie c', released_on: 1.months.ago))
      @movie4 = Movie.create!(movie_attributes(title: 'movie d', released_on: 1.week.ago))
      @movie5 = Movie.create!(movie_attributes(title: 'movie e', released_on: 1.day.ago))
      @movie6 = Movie.create!(movie_attributes(title: 'movie f', released_on: 1.hour.ago))
      @movie7 = Movie.create!(movie_attributes(title: 'movie g', released_on: 1.day.from_now))
    end

    it 'returns a specified number of released movies ordered with the most recent movie first' do
      expect(Movie.recent(2)).to eq([@movie6, @movie5])
    end

    it 'returns a default of 5 released movies ordered with the most recent movie first' do
      expect(Movie.recent).to eq([@movie6, @movie5, @movie4, @movie3, @movie2])
    end
  end

  it 'generates a slug when it is created' do
    movie = Movie.create!(movie_attributes(title: 'X-Men: The Last Stand'))
    expect(movie.slug).to eq('x-men-the-last-stand')
  end

  it 'requires a unique title' do
    movie1 = Movie.create!(movie_attributes)

    movie2 = Movie.new(title: movie1.title)
    movie2.valid?
    expect(movie2.errors[:title].first).to eq('has already been taken')
  end

  it 'requires a unique slug' do
    movie1 = Movie.create!(movie_attributes)

    movie2 = Movie.new(slug: movie1.slug)
    movie2.valid?
    expect(movie2.errors[:slug].first).to eq('has already been taken')
  end
end
