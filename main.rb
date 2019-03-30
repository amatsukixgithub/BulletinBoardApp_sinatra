# bundler設定
require 'bundler/setup'
Bundler.require
# リロードでソースを更新
require 'sinatra/reloader'

# rubyとsqlを簡潔にするgem
require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: './bba.db'
)

# logger用設定 STDOUT=>標準出力
ActiveRecord::Base.logger = Logger.new(STDOUT)

# CSRF対策　悪意のあるフォームからデータが送信されないようにする
require 'rack/csrf'

use Rack::Session::Cookie, secret: "thisissomethingsecretpassword"
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

before do
  @title = 'BulletinBoard'
  @title_h1 = 'BulletinBoard App'
end

# 記事一覧
get '/bulletinboard/top' do
  @title = 'Top|' + @title
  @articles = Article.all
  erb :top
end

# 記事詳細
get '/bulletinboard/article/*' do |id|
  @title = "Article #{id}|" + @title
  @article_detail = Article.find_by(id)
  @article_comments = Comment.where('article_id = ?', id)
  erb :article_detail
end

# 記事新規作成
get '/bulletinboard/article_new' do
  @title = 'New|' + @title
  erb :article_new
end

# 記事登録
post '/bulletinboard/article_create' do
  Article.create(title: params[:title], content: params[:content], user_id: params[:user_id], status: params[:status])
  @db_insert_message = 'Articleを登録しました'
  redirect to('/bulletinboard/article_new')
end

# 記事削除
post '/bulletinboard/article_destroy' do
  Article.find_by(params[:id]).destroy
end

# コメント削除
post '/bulletinboard/comment_close' do
  Comment.update(params[:id], status: 0)
end

# 記事検索
get '/bulletinboard/search/*' do
  # Article.where()
end

# ユーザー詳細
get '/bulletinboard/user/*' do
  # User.
end

# 記事一覧へ
get '/bulletinboard*' do
  redirect to('/bulletinboard/top')
end
