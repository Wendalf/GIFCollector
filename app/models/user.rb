class User < ActiveRecord::Base
	has_many :gifs
	has_secure_password

	def slug
		self.username.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
	end

	def self.find_by_slug(slug)
		self.all.find{|i| i.slug == slug}
	end

	def makedir
      directory_name = Dir.pwd + "/public/users/#{self.id}"
      Dir.mkdir(directory_name)
	end
	
end
