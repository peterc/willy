Thread.new do
  client = Faye::Client.new('http://localhost:9292/fayex')
  client.subscribe('/votes') do |message|
    File.open('/tmp/log.log', 'a') { |f| f.puts message.inspect }
  end
  File.open('/tmp/log.log', 'a') { |f| f.puts "balls" }
end


#Thread.new do
#  client = Faye::Client.new('http://localhost:9292/fayex')
#  10.times do
#    sleep 1
#    client.publish('/messages', 'text' => 'Hellxxxo world')
#  end
#end

