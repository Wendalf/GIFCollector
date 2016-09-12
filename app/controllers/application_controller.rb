require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base
 use Rack::Flash

  configure do

    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      @user ||= User.find(session[:user_id])
      # if @user
      #   @user
      # else
      #   User.find(session[:user_id])
      # end
    end
  end

  get '/' do
    @gifs = Gif.all_descending
    @user = User.find_by_id(session[:user_id])
    erb :index
  end

  post '/search' do
    @tag_names = Tag.all.map {|t| t.name}

    if @tag_names.include?(params[:input])
      @tag = Tag.all.select {|tag| tag.name == params[:input]}.first
      @gifs = @tag.gifs
      erb :'/tags/show'
    else
      flash[:message] = "Nothing found!"
       redirect "/"
    end
  end

  # get '/search' do
  #
  #
  # end



end
