# bundler設定
require 'bundler/setup'
Bundler.require

require 'bcrypt'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: './bba.db'
)

# DB定義
class User < ActiveRecord::Base
end

class UserData
  field :name
  field :email
  field :password_hash
  field :password_salt

  attr_readonly :password_hash, :password_salt

  # ユーザー認証
  def self.authenticate(name, password)
    user = User.where(name: name).first
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  # パスワード暗号化
  def encrypt_password(password)
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end
