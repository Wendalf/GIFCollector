class Tag < ActiveRecord::Base
	has_many :gif_tags
	has_many :gifs, through: :gif_tags
	has_many :users, through: :gifs

	def slug
     name.downcase.split(" ").join("-")
  end

  def self.find_by_slug(slg)
     Tag.all.find{|a| a.slug == slg}
  end
end
