class WebappBaseController < ApplicationController
  before_filter :check_authorization

  def current_user
    user = User.where(token: session['angs_auth_token']).first
    if user
      user
    else
      nil
    end
  end

  def check_authorization
    puts "-webapp-check_authorization-"
    
    unless current_user
      redirect_to '/auth/doorkeeper'
    end
  end

  def authentication_callback
    auth = request.env['omniauth.auth']
    puts "--authentication_callback-"
    hash = auth.to_hash
    token = hash['credentials']['token']
    @user = User.where(user_id: hash["uid"].to_s, token: token).first
    @user = @user? @user : User.new
    puts "-- update token --"
    @user.update_attributes! user_id: hash["uid"].to_s, email: hash["info"]["email"], token: token, expires_at: hash['credentials']['expires_at']

    session['angs_auth_token'] = token

    redirect_to root_path
  end
end