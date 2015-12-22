require 'spec_helper'

describe 'Viewing a movie listing' do
  it 'shows the movie details' do
    movie1 = Movie.create(title: "Iron Man",
                      rating: "PG-13",
                      total_gross: 318412101.00,
                      description: "Tony Stark builds an armored suit to fight the throes of evil",
                      released_on: "2008-05-02")

    visit "http://www.example.com/movies/#{movie1.id}"

    expect(page).to have_text(movie1.title)
    expect(page).to have_text(movie1.rating)
    expect(page).to have_text('$318,412,101.00')
    expect(page).to have_text(movie1.description)
    expect(page).to have_text(movie1.released_on)

  end
end
