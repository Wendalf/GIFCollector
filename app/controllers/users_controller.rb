class GifsController < ApplicationController

   get '/login' do
     erb :'users/login'
   end

   post '/login' do
     @user = User.find_by(username: params[:username])
     redirect ("/gifs")
   end

   get '/signup' do
     erb :'users/signup'
   end

   post '/signup' do
     @user = User.create(params)
     redirect ("/login")
   end


end
