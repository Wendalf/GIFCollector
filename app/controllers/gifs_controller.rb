class GifsController < ApplicationController

  get '/gifs/new' do
    erb :'/gifs/new'
  end

  post '/gifs/new' do
    user = User.find(session[:user_id])
    if !params[:gif].empty?
      gif = Gif.create(filename: params[:gif][:filename], description: params[:description])
      user.gifs << gif

      # create a new folder under public for each user
      user_id = gif.user_id
      gif_file_name = params[:gif][:filename]
      gif_file = params[:gif][:tempfile]
      File.open("./public/users/#{user_id}/#{gif_file_name}", 'w') do |f|
        f.write(gif_file.read)
      end

      # add tags to each gif that's been created
      tags = params[:tags].gsub(" ", "").split(",")
      tags.each do |tag|
        new_tag = Tag.find_or_create_by(name: tag)
        gif.tags << new_tag
      end

      redirect "gifs/#{gif.slug}"
    else
      # Or some kind of error page, with a link to the gifs/new
      redirect "/gifs/new"
    end
   end

  get '/gifs/:slug' do
    @gif = Gif.find_by_slug(params[:slug])
    @tags = @gif.tags.collect{|tag| tag.name}.join(", ")
    if @gif.user_id == session[:user_id]
      erb :'gifs/show'
    else
      erb :'gifs/show_public'
    end
  end

  get '/gifs/:slug/edit' do
    @gif = Gif.find_by_slug(params[:slug])
    if @gif.user_id == session[:user_id]
      @user = User.find(session[:user_id])
      erb :'gifs/edit'
    else
      erb :'gifs/show_public'
    end
  end

  post '/gifs/:slug/edit' do
    user = User.find(session[:user_id])
    gif = Gif.find_by_slug(params[:slug])
    if gif.user_id == user.id
      gif.update(description: params[:description])
      gif.tags.clear
      tags = params[:tags].gsub(" ", "").split(",")
      tags.each do |tag|
        new_tag = Tag.find_or_create_by(name: tag)
        gif.tags << new_tag
      end

      redirect "gifs/#{gif.slug}"
    end
  end

  delete '/gifs/:slug/delete' do 
    gif = Gif.find_by_slug(params[:slug])
    if gif.user_id == current_user.id
      gif.destroy
      redirect "/users/#{current_user.id}"
    end
  end

end
