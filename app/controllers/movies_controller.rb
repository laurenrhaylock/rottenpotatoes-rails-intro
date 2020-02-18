class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    @sort = params[:sort] || session[:sort]
    session[:ratings] = session[:ratings] || @all_ratings
    params[:ratings].nil? ? @rating_param = session[:ratings] : @rating_param = params[:ratings].keys
    #@rating_param = params[:ratings].keys || session[:ratings]
    #save sessions
    session[:sort] = @sort
    session[:ratings] = @rating_param
    @movies = Movie.where(rating: @rating_param).order(@sort)
    if (params[:sort] != session[:sort]) or (params[:ratings] != session[:ratings])
      flash.keep
      redirect_to movies_path(sort: @sort, rating: @rating_param)
      params[:sort] = session[:sort]
      params[:ratings] = session[:ratings]
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
