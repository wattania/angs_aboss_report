class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
    raise "-s-"
  end

  def authentication_callback
    auth = request.env['omniauth.auth']
    render json: auth.to_json
  end
end
