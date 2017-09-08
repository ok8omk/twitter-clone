# coding: UTF-8
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/base'
require_relative './model/db'
require 'date'
 
    # ホーム(タイムライン)
	get '/' do
        # ログイン時にはタイムラインを表示
		if login? then
            # @relations    : 自分のフォロワーID(+自分のID)
            # @tweets       : @relationsのIDを持つツイート情報
			@relation=Relationship.where(user_id: session[:user_id]).select('follow_id').all
			@relations=[]
			@relation.each{|rel|
				@relations.push(rel.follow_id)
			}
			# 自分のidを格納
			@relations.push(session[:user_id])
            # @relationsのIDを持つツイートを時間昇順で取得
            @tweets=Tweet.joins(:user).where(user_id: @relations).select("tweets.*, users.*").reverse_order.all
			erb :index 
        # 非ログイン時にはログイン画面にリダイレクト
		else
			redirect "/login"
		end

	end

    # ログイン画面
	get '/login' do
		erb :login, :layout => :loginLayout 
	end

    # ログイン処理
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

    # アカウント登録画面
	get '/register' do
		erb :register, :layout => :loginLayout 
	end

    # アカウント登録処理
	post '/register' do
		User.create(
			name: params[:name],
			email: params[:email],
			password: params[:password]
		)
		session[:user_id]=User.find_by(email: params[:email]).id 
		redirect "/"
	end

	get '/user/:id/follower' do
    # フォロワー表示画面
		erb :follower
	end

    # フォロー中ユーザー表示画面
	get '/user/:id/follow' do
        # @follow : フォロー中ユーザー情報
        @relationships = Relationship.joins("LEFT JOIN users ON relationships.follow_id = users.id").where(user_id: session[:user_id]).select("relationships.*, users.name").all
		erb :follow
	end

    # フォロー中ユーザー表示画面
	post '/user/:id/follow' do
        p session[:user_id], params[:follow_id].to_i
        r = Relationship.find_by(["user_id = ? AND follow_id = ?", session[:user_id], params[:follow_id]])
        r.destroy
		redirect '/user/' + params[:id] + '/follow'
    end

    # ツイート画面
	get '/tweet' do
		erb :tweet
	end

    # ツイート処理
	post '/tweet' do
		Tweet.create(
			user_id: session[:user_id],
			text: params[:tweet],
			post_time: getTime(Time.now.year,Time.now.month,Time.now.day,Time.now.hour,Time.now.min)
		)
		redirect '/'
	end

    # ユーザー検索画面
	get '/search' do
        @word = params[:word]
        @users = User.where(name: @word).all
		erb :search
	end

    # ユーザープロフィール画面
	get '/user/:id' do
		@user=User.find_by(id: params[:id])
		@isFollow=Relationship.where(user_id: session[:user_id]).where(follow_id: params[:id].to_i).exists?
		@tweets=Tweet.where(user_id: params[:id]).all
		erb :user
	end

    # ログアウト画面(セッションを削除し、ログイン画面にリダイレクト)
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

    get '/setting' do
    	@user=User.find_by(id: session[:user_id])
    	erb :setting
    end

    post '/setting' do
    	@user=User.find_by(id: session[:user_id])
    	@user.name=params[:name]
    	@user.save
    	redirect '/setting'
    end