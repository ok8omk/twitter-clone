# coding: UTF-8
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/base'
require 'cgi'
require_relative './model/db'


	get '/' do
		erb :index 
	end

	get '/login' do
		erb :login
	end

	post '/login' do
		user = User.find_by(email: params[:email])
		if user && user.authenticate(params[:password]) then
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
		redirect "/"
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

	get '/search' do
		erb :search
	end

	get '/user' do
		erb :user
	end