# bundler設定
require 'bundler/setup'
Bundler.require
# リロードでソースを更新
require 'sinatra/reloader'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: './bba.db'
)

# logger用設定 STDOUT=>標準出力
# ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.logger = Logger.new('sinatra.log')

# CSRF対策　悪意のあるフォームからデータが送信されないようにする
require 'rack/csrf'

use Rack::Session::Cookie
set :session_secret, 'somethingverysecret1234'

use Rack::Csrf, raise: true

helpers do
  def csrf_tag
    Rack::Csrf.csrf_tag(env)
  end

  def csrf_token
    Rack::Csrf.csrf_token(env)
  end

  def h(str)
    Rack::Utils.escape_html(str)
  end
end

# DB定義
class User < ActiveRecord::Base
end

class Article < ActiveRecord::Base
end

class Comment < ActiveRecord::Base
end

class Favorite < ActiveRecord::Base
end

# configure do
#   # enable :sessions
#   use Rack::Session::Cookie
#   set :session_secret, 'somethingverysecret1234'
#   # use Rack::Session::Cookie,  :key => 'rack.session',
#   #                             :expire_after => 60,
#   #                             :secret => Digest::SHA256.hexdigest(rand.to_s)
# end

before do
  @title = 'BulletinBoard'
  @title_h1 = 'BulletinBoard App'
end

# 記事一覧画面
get '/bulletinboard/top' do
  # logger.info session

  @title = 'Top|' + @title
  @articles = Article.all
  erb :top
end

# 記事詳細画面
get '/bulletinboard/article/*' do |id|
  @title = "Article #{id}|" + @title
  @article_detail = Article.find_by(id)
  @article_comments = Comment.where('article_id = ?', id)
  erb :article_detail
end

# 記事新規作成画面
get '/bulletinboard/article_new' do
  @title = 'New|' + @title
  erb :article_new
end

# 記事新規作成処理
post '/bulletinboard/article_create' do
  Article.create(title: params[:title], content: params[:content], user_id: session[:user_id], status: 1)
  @db_insert_message = 'Articleを登録しました'
  redirect to('/bulletinboard/article_new')
end

# 記事削除処理
post '/bulletinboard/article_destroy' do
  Article.find(params[:id]).destroy
end

# コメント登録処理
post '/bulletinboard/comment_new' do
  Comment.create(user_id: 1, article_id: params[:article_id], content: params[:content], status: 1)
end

# コメント削除処理
post '/bulletinboard/comment_close' do
  Comment.update(params[:id], status: 0)
end

# ユーザー登録画面
get '/bulletinboard/user_new' do
  @title = 'UserNew|' + @title
  erb :user_new
end

# ログイン画面
get '/bulletinboard/user_login' do
  @title = 'UserLogin|' + @title
  session.clear
  erb :user_login
end

# ログイン処理
post '/bulletinboard/login' do
  user = User.find_by(mail: params[:input_user_mail])
  if (user && user.password_hash == BCrypt::Engine.hash_secret(params[:input_user_password], user.password_salt))
    session[:user_id] = user.id
    session[:user_name] = user.name
  end
  redirect to('/bulletinboard/top')
end

# ログアウト処理
get '/bulletinboard/user_logout' do
  session.clear
  redirect to('/bulletinboard/top')
end

# ユーザー登録処理
post '/bulletinboard/user_create' do
  password_salt = BCrypt::Engine.generate_salt
  password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)
  user = User.create(name: params[:name], password_hash: password_hash, password_salt: password_salt, comment: params[:comment], mail: params[:mail])

  session[:user_id] = user.id
  session[:user_name] = user.name
  redirect to('/bulletinboard/top')
end

# # ユーザー画面
# get '/bulletinboard/user/*' do |id|
#   # User.
# end

# # 記事検索処理
# get '/bulletinboard/search/*' do
#   # Article.where()
# end

# # 管理者画面
# get '/bulletinboard/regista' do
#   # erb :regista
# end

# 記事一覧画面
get '/bulletinboard*' do
  redirect to('/bulletinboard/top')
end
