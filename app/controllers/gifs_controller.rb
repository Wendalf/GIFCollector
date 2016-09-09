class GifsController < ApplicationController

  # get '/gifs' do
  #   if logged_in?
  #     user = User.find(session[:user_id])
  #     @gifs = user.gifs
  #     erb :'/gifs/gifs'
  #   else
  #     redirect '/login'
  #   end
  # end

  post '/gifs/new' do
    user = User.find(session[:user_id])
    if !params[:gif].empty?
      gif = Gif.create(filename: params[:gif][:filename], description: params[:description])
      user.gifs << gif
      user_id = gif.user_id
      gif_file_name = params[:gif][:filename]
      gif_file = params[:gif][:tempfile]

      File.open("./public/users/#{user_id}/#{gif_file_name}", 'w') do |f|
        f.write(gif_file.read)
      end

      redirect "gifs/#{gif.slug}"
    else
      #Or some kind of error page, with a link to the gifs/new
      redirect "/users/#{user.id}"
    end
   end

  get '/gifs/:slug' do
    @gif = Gif.find_by_slug(params[:slug])

    if logged_in? && @gif.user_id == session[:user_id]
      @user = User.find(session[:user_id])
      erb :'gifs/edit'
    elsif logged_in?
      erb :'gifs/show'
    else
      redirect '/login'
    end

  end

  post '/gifs/:slug/edit' do
    user = User.find(session[:user_id])
    gif = Gif.find_by_slug(params[:slug])
    if gif.user_id == user.id
      gif.update(description: params[:description])
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
