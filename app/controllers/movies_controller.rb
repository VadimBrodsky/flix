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
    @movie.update(movie_params)
    redirect_to movie_path(@movie)
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.create(movie_params)
    redirect_to movie_path(@movie)
  end

  private

  def movie_params
    # Restrict which attributes are allowed to be received from the form
    # This is a security feature, to avoid mass assingment vulnerability
    # .permit - specify the permitter attributes
    # .require - will raise an exception if the given key isn't found
    # .permit! - make all attributes updateable
    params.require(:movie).permit(
      :title, :description, :rating, :released_on, :total_gross
    )
  end
end
