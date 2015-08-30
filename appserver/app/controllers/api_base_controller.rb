class ApiBaseController < ApplicationController
  before_filter :check_authorization

  def check_authorization
    

    signature = ENV['SERVICE_SIGNATURE']
    authorize = ENV['AUTHORIZE_SERVER']
    
    if !signature
      response.status = 500
      render json: {authorized: false, error: 'Empty Service Signature'} and return
    end

    if !authorize
      response.status = 500
      render json: {authorized: false, error: 'Empty Authorization Server'} and return
    end

    authorization = request.headers['Authorization'].to_s
    ## remove Baerer
    _auth = authorization.split ' '
    authorization = _auth.last if (_auth.size == 2) and _auth.last

    auth_url = "#{authorize}"
    if authorization
      @user = User.where(token: authorization).last 
      if !@user or @user.expires_at.to_i < DateTime.now.to_i
        conn = Faraday.new(:url => auth_url) do |c|
          c.use Faraday::Request::UrlEncoded  # encode request params as "www-form-urlencoded"
          c.use Faraday::Response::Logger     # log request & response to STDOUT
          c.use Faraday::Adapter::NetHttp     # perform requests with Net::HTTP
        end
        res = conn.get 'check_key.json', signature: '-signature-', oauth_token: authorization

        parsed_response = JSON.parse res.body rescue {}

        if parsed_response['user_id']
          @user = User.where(user_id: parsed_response['user_id'].to_s).last
          @user = @user? @user : User.new
          @user.update_attributes!(user_id: parsed_response['user_id'],
                                email: parsed_response['email'],
                                token: authorization,
                                expires_at: parsed_response['expires_at'])
        else
          response.status = 401
          render json: {authorized: false} and return
        end
      end
    else
      response.status = 401
      render json: {authorized: false} and return
    end
  end
end
