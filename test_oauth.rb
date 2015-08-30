require 'optparse'
require 'oauth2'
require 'yaml'

CLIENT_ID = 'a05c6e58ac5fba8769852ed034778c36eaf6040d6ac00dc35a0b850819877ada'
CLIENT_SECRET='705114e43807385be09ddbe059cf1dd442e874134641cab04cbffd5debcdc4dc'
AUTH_HOST="http://10.211.55.15:3001"
CALLBACK_URL = 'urn:ietf:wg:oauth:2.0:oob'

TOKEN_FILE = 'token.yml'
CODE_FILE  = 'auth_code.yml'

def get_token
  File.open(TOKEN_FILE, 'w') unless File.exist? TOKEN_FILE
  token = YAML.load_file TOKEN_FILE
  token or token.is_a?(Hash) ? token : {}
end

def store_token token
  File.open(TOKEN_FILE,'w') do |h| 
    values = {}
    token.to_hash.each{|k, v| values[k.to_s] = v }
    h.write values.to_yaml
  end
  token
end

def get_authorization_code
  File.open(CODE_FILE, 'w') unless File.exist? CODE_FILE
  config = YAML.load_file CODE_FILE
  if config.is_a?(Hash)
    code = config['code']
    File.delete CODE_FILE if code
    code
  else
    return nil
  end
end

def plz_login_prompt client 
  puts
  puts "Please Login "
  puts client.auth_code.authorize_url(:redirect_uri => CALLBACK_URL)  
  puts ""
  nil
end

def main client, auth_code = nil
  
  token = nil

  if auth_code
    begin
      token = store_token client.auth_code.get_token(auth_code, :redirect_uri => CALLBACK_URL)#, :headers => {'Authorization' => 'Basic some_password'})
    rescue OAuth2::Error => e
      plz_login_prompt client
      return nil
    end
  else
    stored_token = get_token
    access_token = stored_token['access_token']
    if access_token
      token = OAuth2::AccessToken.new client, access_token, stored_token
      if token.refresh_token
        if token.expired?
          puts "(token expired)"
          p token
          puts
          token = store_token token.refresh!  
          puts " - new token -"
          p token 
          puts
        else
          puts " found valid token ! "
          p token 
          puts
        end
      else
        plz_login_prompt client
      end
    else
      plz_login_prompt client
    end
  end

  token
end

def call_api a_token 
  client = OAuth2::Client.new(CLIENT_ID, CLIENT_SECRET, :site => 'http://10.211.55.15:3005')
  puts "-- call_api -> "
  access_token = a_token.token
  puts
  token = store_token a_token.refresh! if a_token.expired?
  stored_token = get_token
  api_token = OAuth2::AccessToken.new client, access_token, stored_token
  yield api_token
  token
end

if __FILE__ == $0
  puts "------------------------------"
  client = OAuth2::Client.new(CLIENT_ID, CLIENT_SECRET, :site => AUTH_HOST)
  token = main client, ARGV[0]
  if token 
    puts
    #p token.get('/me').parsed

    call_api token do |api_token|
      puts "-x-"
      p api_token.get('/api/report').parsed

    end

    #puts "--- call api ---"
    #token = store_token client.auth_code.get_token(auth_code, :redirect_uri => CALLBACK_URL)
  end
  puts
end