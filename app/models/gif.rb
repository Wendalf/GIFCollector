class Gif < ActiveRecord::Base
	belongs_to :user
	has_many :gif_tags
	has_many :tags, through: :gif_tags

	def slug
		self.filename.downcase.strip.gsub(' ', '-').gsub('.gif', '').gsub(/[^\w-]/, '')
	end

	def self.find_by_slug(slug)
		self.all.find{|i| i.slug == slug}
	end

	def self.all_descending
		self.all.reverse
	end
end
