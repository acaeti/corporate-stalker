require 'sinatra'
require 'net-ldap'
require 'dotenv'

#load .env variables
Dotenv.load

LDAP_HOST = ENV["LDAP_HOST"]
LDAP_BASE = ENV["LDAP_BASE"]
LDAP_DOMAIN = ENV["LDAP_DOMAIN"]
LDAP_USERNAME = ENV["LDAP_USERNAME"]
LDAP_PASSWORD = ENV["LDAP_PASSWORD"]
LDAP_PORT = ENV["LDAP_PORT"]
LDAP_ENCRYPTION = ENV["LDAP_ENCRYPTION"].intern

APP_PORT = ENV["APP_PORT"]
APP_MODE = ENV["APP_MODE"]

#pid management, requires the directory to be writable
File.open('server.pid', 'w') {|f| f.write Process.pid }

######################

def ldap_user_and_photo(samaccountname)
  net_ldap_settings = {
    :host => LDAP_HOST,
    :base => LDAP_BASE,
    :port => LDAP_PORT,
    :encryption => LDAP_ENCRYPTION,
    :auth => {
      :method => :simple,
      :username => "#{LDAP_USERNAME}@#{LDAP_DOMAIN}",
      :password => LDAP_PASSWORD
    }
  }
  
  ldap_connection = Net::LDAP.new(net_ldap_settings)
  
  search_parameter = samaccountname

  result_attributes = ["sAMAccountName", "thumbnailphoto"]
  
  search_filter = Net::LDAP::Filter.eq("sAMAccountName", search_parameter)
  
  users = ldap_connection.search(:filter => search_filter, :attributes => result_attributes)

  if ldap_connection.get_operation_result.code == 0
    user = users[0]
    return user
  else
    return nil
  end
end

######################

set :port, APP_PORT
set :environment, APP_MODE

get '/:samaccountname' do
  samaccountname = params[:samaccountname]
  
  #strip file extension
  samaccountname = samaccountname[0..-5]
  
  user = ldap_user_and_photo(samaccountname)
  
  #test if user returned from AD
  unless(user.nil?)
    #test if thumbnail returned from AD
    if user.attribute_names.include?(:thumbnailphoto)
      content_type 'image/jpeg'
      user.thumbnailPhoto[0]
    else
      #no pic, 404
      404
    end
  else
    #no user, 404
    404
  end  
end