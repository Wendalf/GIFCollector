class User < ActiveRecord::Base
	has_many :gifs
	has_secure_password
end