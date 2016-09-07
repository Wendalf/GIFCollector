require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
  
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  helpers do
    def logged_in?
      !!session[:id]
    end

    def current_user
      User.find(session[:id])
    end
  end

  get '/' do
    redirect '/index' if logged_in?
    redirect '/login'
  end

  get '/index' do
    redirect '/login' unless logged_in?
    @gifs = Gif.all
    @user = current_user
    erb :index
  end

end
