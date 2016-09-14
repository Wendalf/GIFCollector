class UsersController < ApplicationController

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
      flash[:message] = "Thanks for signing up!"
      redirect '/'
    else
      flash[:message] = "Please fill up all fields!"
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
      flash[:message] = "Welcome back #{current_user.username.capitalize}!"
      redirect "/users/#{user.id}"
    else
      flash[:message] = "Please enter a valid username and password."
      redirect '/login'
    end
  end

  get '/users/:id' do

    @user = User.find(params[:id])
    @gifs = @user.gifs.reverse
    if logged_in?
      if @user.id == session[:user_id]
        @username = "My"
      else
        @username = @user.username.capitalize + "'s"
      end
    else
      @username = @user.username.capitalize + "'s"
    end

    erb :'/users/show'

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