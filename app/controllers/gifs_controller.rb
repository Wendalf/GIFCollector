class GifsController < ApplicationController

  get '/gifs/new' do
    if logged_in?
      erb :'/gifs/new'
    else
      redirect '/login'
    end

  end

  post '/gifs/new' do
    user = User.find(session[:user_id])
    if params[:gif]

      gif = Gif.create(filename: params[:gif][:filename])
      usergif = user.gifs.all.find{|allgif| allgif.filename == gif.filename}
      if usergif
        flash[:message] = "You've uploaded this gif! Edit it here."
        gif.destroy
        redirect "gifs/#{usergif.id}/edit"
      else
        gif.update(description: params[:description])
        user.gifs << gif

        # create a new folder under public for each user
        user_id = gif.user_id
        gif_file_name = params[:gif][:filename]
        gif_file = params[:gif][:tempfile]
        File.open("./public/users/#{user_id}/#{gif_file_name}", 'w') do |f|
          f.write(gif_file.read)
        end

        # add tags to each gif that's been created
        tags = params[:tags].downcase.gsub(" ", "").split(",")
        tags.each do |tag|
          new_tag = Tag.find_or_create_by(name: tag)
          gif.tags << new_tag
        end

        flash[:message] = "Successfully Uploaded GIF!"
        redirect "gifs/#{gif.id}"
      end
    else
      flash[:message] = "Please include a gif file!"
      redirect "/gifs/new"
    end
   end

  get '/gifs/:id' do
    @gif = Gif.find_by_id(params[:id])
    if @gif.user_id == session[:user_id]
      erb :'gifs/show'
    else
      erb :'gifs/show_public'
    end
  end

  get '/gifs/:id/edit' do
    @gif = Gif.find_by_id(params[:id])
    @tags = @gif.tags.collect{|tag| tag.name}.join(", ")
    if @gif.user_id == session[:user_id]
      @user = User.find(session[:user_id])
      erb :'gifs/edit'
    else
      erb :'gifs/show_public'
    end
  end

  post '/gifs/:id/edit' do
    user = User.find(session[:user_id])
    gif = Gif.find_by_id(params[:id])
    if gif.user_id == user.id
      gif.update(description: params[:description])
      gif.tags.clear
      tags = params[:tags].gsub(" ", "").split(",")
      tags.each do |tag|
        new_tag = Tag.find_or_create_by(name: tag.downcase)
        if !gif.tags.include?(new_tag)
          gif.tags << new_tag
        end
      end

      redirect "gifs/#{gif.id}"
    end
  end

  delete '/gifs/:id/delete' do
    gif = Gif.find_by_id(params[:id])
    if gif.user_id == current_user.id
      gif.destroy
      redirect "/users/#{current_user.id}"
    end
  end




end
