# coding: UTF-8
require 'bcrypt'
require 'active_record'

# DB設定ファイルの読み込み
ActiveRecord::Base.configurations = YAML.load_file('./model/database.yml')
ActiveRecord::Base.establish_connection('development')

  Encoding.default_external = 'UTF-8'


  	configure do
    	# for sessions
    	set :sessions, true
    	set :session_secret, 'My app secret abcde!!!'
    	set :environment, :production

    	# for inline_templates
    	set :inline_templates, true
 	 end


class User < ActiveRecord::Base
	validates :password_digest, presence: true
   	validates :name, uniqueness: true, presence: true,length: {minimum: 2, maximum:  10}

 	 # for helper methods
 	 has_secure_password
end
	# coding: UTF-8
helpers do
	def login?
		if session[:user_id] == nil then
			return false
		else
			return true
		end
	end

	def login_user
		User.find_by(id: session[:user_id])
	end


	def logout
		session.delete(:user_id)
	end
end

class Tweet < ActiveRecord::Base
end

class RelationShip < ActiveRecord::Base
end
