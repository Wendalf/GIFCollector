class User < ActiveRecord::Base
	has_many :gifs
	has_secure_password

	def slug
     name.downcase.split(" ").join("-")
  end

  def self.find_by_slug(slg)
     User.all.find{|a| a.slug == slg}
  end
end
