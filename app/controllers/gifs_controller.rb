class GifsController < ApplicationController

  get '/gifs/new' do
    if logged_in?
      erb :'/gifs/new'
    else
      redirect '/login'
    end

  end

  post '/gifs/new' do
    user = current_user

    if params[:gif]

      gif = Gif.new(filename: params[:gif][:filename], description: params[:description])
      usergif = user.gifs.find_by(filename: params[:gif][:filename])

      if usergif
        flash[:message] = "You've uploaded this gif! Edit it here."
        redirect "gifs/#{usergif.id}/edit"
      else
        gif.save
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
      @user = current_user
      erb :'gifs/edit'
    else
      erb :'gifs/show_public'
    end
  end

  post '/gifs/:id/edit' do
    user = current_user
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
