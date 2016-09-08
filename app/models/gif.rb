class Gif < ActiveRecord::Base
	belongs_to :user
	has_many :gif_tags
	has_many :tags, through: :gif_tags

	def slug
     name.downcase.split(" ").join("-")
  end

  def self.find_by_slug(slg)
     Gif.all.find{|a| a.slug == slg}
  end

end
