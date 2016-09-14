class User < ActiveRecord::Base
	has_many :gifs
	has_secure_password
	after_save :makedir

	def makedir
      directory_name = Dir.pwd + "/public/users/#{self.id}"
      Dir.mkdir(directory_name)
	end

end
