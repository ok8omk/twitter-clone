
# coding: UTF-8
require 'sinatra'
require 'sinatra/reloader'

	get '/' do
		erb :index 
	end

	get '/login'
		erb :login
	end

	get '/register'
		erb :register
	end

	get '/user/follower'
		erb :follower
	end

	get '/user/follow'
		erb :follow
	end

	get '/tweet'
		erb :tweet
	end

	get '/search'
		erb :search
	end

	get '/user'
		erb :user
	end