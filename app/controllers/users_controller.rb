class GifsController < ApplicationController

   get '/signup' do
    if logged_in?
      redirect '/'
    else
      erb :'users/signup'
    end
   end

   post '/signup' do
    user = User.new(params)
    if user.save && (user.username != '') && (user.email != '')
      session[:user_id] = user.id
      redirect '/'
    else
      redirect '/signup'
    end
   end

   get '/login' do
    if logged_in?
      redirect '/gifs'
    else
     erb :'users/login'
    end
   end

   post '/login' do
    @user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/tweets'
    else
      redirect ("/gifs")
    end
   end

  get '/logout' do
    if logged_in?
      session.clear
      redirect '/login'
    else
      redirect '/'
    end
  end



end
