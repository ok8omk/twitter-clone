
# coding: UTF-8
require 'sinatra'
require 'sinatra/reloader'

	get '/' do
		erb :index 
	end

	get '/login' do
		erb :login
	end

	get '/register' do
		erb :register
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