# coding: UTF-8
require 'active_record'
require 'date'

# DB設定ファイルの読み込み
ActiveRecord::Base.establish_connection(
	adapter: "mysql2",
	database: "twitter",
	host: "localhost",
	username: "root",
	password: "",
	encoding: "utf8"
)

  Encoding.default_external = 'UTF-8'


  	configure do
    	# for sessions
    	set :sessions, true
    	set :session_secret, 'My app secret abcde!!!'
    	set :environment, :production

    	# for inline_templates
    	set :inline_templates, true
 	 end

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

	def getTime (d)
		date=d
		"#{date.month}月#{date.day}日#{date.hour}時#{date.min}分"
	end
end

class User < ActiveRecord::Base
   	validates :name, uniqueness: true, presence: true,length: {minimum: 2, maximum:  10}
   	validates :pass, uniqueness: true, presence: true
   	has_many :tweets
    has_many :relationships
end

class Tweet < ActiveRecord::Base
    belongs_to :user
end

class Relationship < ActiveRecord::Base
    belongs_to :user
end
