class MoviesController < ApplicationController
  def index
    @movies = Movie.all
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def update
    @movie = Movie.find(params[:id])

    # Restrict which attributes are allowed to be received from the form
    # This is a security feature, to avoid mass assingment vulnerability
    # .permit - specify the permitter attributes
    # .require - will raise an exception if the given key isn't found
    # .permit! - make all attributes updateable
    movie_params = params.require(:movie).permit(
      :title, :description, :rating, :released_on, :total_gross
    )
    @movie.update(movie_params)
    redirect_to movie_path(@movie)
  end
end
