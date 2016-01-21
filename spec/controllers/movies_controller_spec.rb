require 'spec_helper'

describe MoviesController do
  before do
    @movie = Movie.create!(movie_attributes)
  end

  context 'when not signed in as an admin user' do
    before do
      @user = User.create!(user_attributes)
      session[:user_id] = @user
    end

    it 'cannot access new' do
      get :new
      expect(response).to redirect_to(root_path)
    end

    it 'cannot access create' do
      post :create
      expect(response).to redirect_to(root_path)
    end

    it 'cannot access edit' do
      get :edit, id: @movie
      expect(response).to redirect_to(root_path)
    end

    it 'cannot access update' do
      patch :update, id: @movie
      expect(response).to redirect_to(root_path)
    end

    it 'cannot access destroy' do
      delete :destroy, id: @movie
      expect(response).to redirect_to(root_path)
    end
  end
end
