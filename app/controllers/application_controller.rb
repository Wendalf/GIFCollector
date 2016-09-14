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
      User.find(session[:user_id])
    end
  end

  get '/' do
    @gifs = Gif.all_descending
    gif = Gif.all.find{|gif| gif.filename == "secret007"}
    if gif
      gif.destroy
      @gifs = Gif.all.shuffle
    end
    erb :index
  end

  post '/search' do
    @tag_names = Tag.all.map {|t| t.name}
    input = params[:input].downcase.gsub(" ", "")
    if @tag_names.include?(input)
      @tag = Tag.all.find{|tag| tag.name == input}
      @gifs = @tag.gifs
      erb :'/tags/show'
    else
      flash[:message] = "Nothing found!"
       redirect "/"
    end
  end

  get '/random' do
    @gif = Gif.all.find{|gif| gif.filename == "secret007"}
    if @gif
     @gif.destroy
    end

    Gif.create(filename: "secret007", description: "1234567890")
    redirect '/'
  end

end
