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

    authorization = request.headers['Authorization']
    if authorization
      @user = User.where(token: authorization).last 
      if !@user or @user.expires_at < DateTime.now

        conn = Faraday.new(:url => authorize) do |faraday|
          faraday.request  :url_encoded             # form-encode POST params
        end

        response = conn.get '/' do |request|
          request.params['signature'] = signature
          request.params['oauth_token'] = authorization
          request.headers['Content-Type'] = 'application/json'
          request.body = "{some: body}"
        end

        puts
        p response
        raise "-1-"

        party_response = HTTParty.get("#{authorize}/check_key.json", query: {signature: signature, oauth_token: authorization})        
        parsed_response = party_response.parsed_response
        if parsed_response['user_id']
          @user = User.where(user_id: parsed_response['user_id']).last
          @user = @user? @user : User.new
          @user.update_attributes(user_id: parsed_response['user_id'],
                                email: parsed_response['email'],
                                token: authorization,
                                expires_at: Marshal.load(parsed_response['expires_at'].force_encoding('UTF-8')))
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
