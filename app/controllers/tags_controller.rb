class TagsController < ApplicationController

	get '/tags/:slug' do
		@tag = Tag.find_by_slug(params[:slug])
		@gifs = @tag.gifs
		erb :'/tags/show'
	end
end
