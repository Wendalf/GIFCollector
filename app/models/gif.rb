class Gif < ActiveRecord::Base
	belongs_to :user
	has_many :gif_tags
	has_many :tags, through: :gif_tags
end