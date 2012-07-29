Thread.new do
  client = Faye::Client.new('http://localhost:9292/fayex')
  client.subscribe('/messages') do |message|
    puts message.inspect
  end
end

#Thread.new do
#  client = Faye::Client.new('http://localhost:9292/fayex')
#  10.times do
#    sleep 1
#    client.publish('/messages', 'text' => 'Hellxxxo world')
#  end
#end