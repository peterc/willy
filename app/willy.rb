require 'bundler/setup'
require 'sinatra'
require 'sass'
require 'faye'
require 'ohm'
require 'ohm/contrib'
require 'sinatra/flash'
require 'json'

Ohm.connect thread_safe: true

$: << File.expand_path('../..', __FILE__)

class Willy < Sinatra::Base
  set :public_folder, File.dirname(__FILE__) + "/../public"

  SECRET_WE_DONT_CARE_ABOUT = 'fdsias89dfoifnkdasfdsay8923jbk'

  use Rack::Session::Cookie, :key => 'willy',
                             :expire_after => 2592000, 
                             :secret => SECRET_WE_DONT_CARE_ABOUT
                             
  set :session_secret, SECRET_WE_DONT_CARE_ABOUT
  register Sinatra::Flash
end

Dir['app/models/*.rb'].each { |f| require f }
Dir['app/handlers/*.rb'].each { |f| require f }
