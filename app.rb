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
		p params[:name]
		User.create(
			name: params[:name],
			email: params[:email],
			password: params[:password]
		)
		redirect "/login"
	end

    # フォロワー表示画面
	get '/user/follower' do
		erb :follower
	end

    # フォロー中ユーザー表示画面
	get '/user/follow' do
		erb :follow
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
			post_time: Time.now
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
		@tweets=Tweet.where(user_id: params[:id]).all
		erb :user
	end

    # ログアウト画面(セッションを削除し、ログイン画面にリダイレクト)
    get '/logout' do
        logout
        redirect '/login'
    end
