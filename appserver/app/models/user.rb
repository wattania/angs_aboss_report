class User < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :user_id, :email, :token, :expires_at
end
