class MoviesController < ApplicationController
  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]
  before_action :set_movie, only: [:show, :edit, :update, :destroy]

  def index
    case params[:scope]
    when 'flops'
      @movies = Movie.flops
    when 'hits'
      @movies = Movie.hits
    when 'recent'
      @movies = Movie.recent
    when 'upcoming'
      @movies = Movie.upcoming
    else
      @movies = Movie.released
    end
  end

  def show
    @fans = @movie.fans
    @genres = @movie.genres

    if current_user
      @current_favorite = current_user.favorites.find_by(movie_id: @movie)
    end
  end

  def edit
  end

  def update
    if @movie.update(movie_params)
      redirect_to movie_path(@movie), notice: 'Movie successfully updated!'
    else
      render :edit
    end
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      redirect_to movie_path(@movie), notice: 'Movie successfully created!'
    else
      render :new
    end
  end

  def destroy
    @movie.destroy
    redirect_to movies_path, alert: 'Movie successfully deleted!'
  end

  private

  def movie_params
    # Restrict which attributes are allowed to be received from the form
    # This is a security feature, to avoid mass assingment vulnerability
    # .permit - specify the permitter attributes
    # .require - will raise an exception if the given key isn't found
    # .permit! - make all attributes updateable
    params.require(:movie).permit(
      :title, :slug, :description, :rating, :released_on, :total_gross, :cast,
      :director, :duration, :image_file_name, genre_ids: []
    )
  end

  def set_movie
    @movie = Movie.find_by!(slug: params[:id])
  end
end
