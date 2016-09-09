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
      user.makedir
      redirect '/'
      #NEED to add seccessful created user message
    else
      #NEED to add error message
      redirect '/signup'
    end
  end

  get '/login' do
    if logged_in?
      redirect "/"
    else
     erb :'users/login'
    end
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/users/#{user.id}"
      #OR redirect to home page.(we need to decided later)
      #NEED to add seccessful logged in message
    else
      #NEED to add login error message
      redirect '/login'
    end
  end

  get '/users/:id' do

    @user = User.find(params[:id])

    if logged_in? && @user == current_user
      @gifs = @user.gifs
      erb :'/users/show'
    else
      redirect '/login'
    end

  end

  get '/signout' do
    if logged_in?
      session.clear
      redirect '/'
    else
      redirect '/'
    end
  end



end
