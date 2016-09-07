class GifsController < ApplicationController

   get '/gifs/new' do
     erb :'gifs/new'
   end

   post '/gifs/new' do
     @gif_file_name = params[:gif][:filename]
     gif_file = params[:gif][:tempfile]

     File.open("public/#{@gif_file_name}", "wb") do |f|
       f.write(gif_file.read)
     end

    #  gif = Gif.find_or_create_by(params[:gif])
    #  redirect "gifs/#{gif.id}"

      erb :show

   end

  get 'gifs/:id' do
    erb :'gifs/show'
  end

  get '/show'


end
