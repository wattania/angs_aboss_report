class ApiBaseController < ApplicationController
  before_filter :check_authorization

  def check_authorization
    puts "-- check_authorization --"
    p ENV['AUTH_SERVER_NAME']
    puts
    authorization = request.headers['Authorization']
    if authorization
      @user = User.where(token: authorization).last 
      if !@user or @user.expires_at < DateTime.now
        party_response = HTTParty.get("http://our_service_url/check_key.json", query: {'signature' => our_unique_req_signature, 'oauth_token' => authorization})        
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
