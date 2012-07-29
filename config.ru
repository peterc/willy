$: << File.expand_path('../app', __FILE__)

require 'willy'

Faye::WebSocket.load_adapter('thin')
faye = Faye::RackAdapter.new(
  mount: '',
  timeout: 20
)

run Willy
map('/fayex') { run faye }

require 'parttwo'