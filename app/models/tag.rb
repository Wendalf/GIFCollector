class Tag < ActiveRecord::Base
	has_many :gif_tags
	has_many :gifs, through: :gif_tags
	has_many :users, through: :gifs

	def slug
		self.name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
	end

	def self.find_by_slug(slug)
		self.all.find{|i| i.slug == slug}
	end

end
