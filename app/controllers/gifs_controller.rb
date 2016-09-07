class GifsController < ApplicationController

   get '/gifs/new' do
     erb :'gifs/new'
   end

   post '/gifs/new' do
     gif_file_name = params[:gif][:filename]
     gif_file = params[:gif][:tempfile]
     # binding.pry
     File.open("./public/gifs/#{gif_file_name}", 'w') do |f|
       f.write(gif_file.read)
     end

     # File.write(File.expand_path("public/#{gif_file_name}"), File.open(gif_file))

      gif = Gif.create(filename: params[:gif][:filename])

      redirect "gifs/#{gif.id}"
   end

  get '/gifs/:id' do
    @gif = Gif.find(params[:id])
    erb :'gifs/show'
  end


end
