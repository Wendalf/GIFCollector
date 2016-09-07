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
    erb :index
  end



end
