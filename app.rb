# coding: UTF-8
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/base'
require 'cgi'
require_relative './model/db'
require 'date'


	get '/' do
		@relation=Relationship.where(user_id: session[:user_id]).all
		@tweets=[]
		@relation.each{|rel|
			@tweet=Tweet.where(user_id: rel.follow_id).all.each{|tw|
				@tweets.push(tw)
			}
		}
		@tweets
		erb :index 
	end

	get '/login' do
		erb :login
	end

	post '/login' do
		user = User.find_by(email: params[:email])
		if user && (user.password == params[:password]) then
			session[:user_id] = user.id
		else

		end

		if login? then
			redirect "/"
		else
			redirect "/login"
		end
	end

	get '/register' do
		erb :register
	end

	post '/register' do
		p params[:name]
		User.create(
			name: params[:name],
			email: params[:email],
			password: params[:password]
		)
		redirect "/login"
	end

	get '/user/follower' do
		erb :follower
	end

	get '/user/follow' do
		erb :follow
	end

	get '/tweet' do
		erb :tweet
	end

	post '/tweet' do
		Tweet.create(
			user_id: session[:user_id],
			text: params[:tweet],
			post_time: Date.today.to_time
		)
		p session[:user_id]
		redirect '/'
	end
	get '/search' do
		erb :search
	end

	get '/user/:id' do
		erb :user
	end