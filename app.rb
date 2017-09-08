# coding: UTF-8
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/base'
require_relative './model/db'
require 'date'


	get '/' do
		if login? then
			@relation=Relationship.where(user_id: session[:user_id]).select('follow_id').all
			@relations=[]
			@relation.each{|rel|
				@relations.push(rel.follow_id)
			}
			#自分のidを格納
			@relations.push(session[:user_id])
			p @relations
			@tweets=Tweet.where(user_id: @relations).reverse_order.all
			@tweets
			erb :index 
		else
			redirect "/login"
		end

	end

	get '/login' do
		erb :login, :layout => :loginLayout 
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
		erb :register, :layout => :loginLayout 
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

	get '/user/:id/follower' do
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
			post_time: getTime(Time.now.year,Time.now.month,Time.now.day,Time.now.hour,Time.now.min)
		)
		redirect '/'
	end


    # Search page

	get '/search' do
        @word = params[:word]
        @users = User.where(name: @word).all
		erb :search
	end

	get '/user/:id' do
		@user=User.find_by(id: params[:id])
		@isFollow=Relationship.where(user_id: session[:user_id]).where(follow_id: params[:id].to_i).exists?
		@tweets=Tweet.where(user_id: params[:id]).all
		erb :user
	end

    get '/logout' do
        logout
        redirect '/login'
    end

    post '/follow' do
    	if params[:follow] == 'follow' then
    		Relationship.create(
    			user_id: session[:user_id],
    			follow_id: params[:user_id]
    			)
    	else
    		Relationship.delete_all(["user_id = ? AND follow_id = ?",session[:user_id], params[:user_id]])
    	end
    	uri = '/user/'+params[:user_id]
    	redirect uri
    end








