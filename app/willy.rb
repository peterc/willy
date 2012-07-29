require 'bundler/setup'
require 'sinatra'
require 'sass'
require 'faye'
require 'ohm'
require 'ohm/contrib'

$: << File.expand_path('../..', __FILE__)

class Willy < Sinatra::Base
  set :public_folder, File.dirname(__FILE__) + "/../public"
end

Dir['app/models/*.rb'].each { |f| require f }
Dir['app/handlers/*.rb'].each { |f| require f }
