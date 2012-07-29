class Willy
  post '/poll' do
  	question = params[:question] || ''
  	answers = params[:answer]

  	unless question.to_s.length > 5 && answers.all? { |a| !a.empty? }
  	  halt erb 'Invalid inputs!!'
  	end

  	poll = Poll.create question: question, ip: request.ip

  	answers.each do |answer|
  	  poll.answers.push(Answer.create text: answer)
  	end

  	session[:tokens] ||= []
  	session[:tokens] << poll.token

  	redirect "#{poll.id}"
  end

  post '/poll/:id/activate' do
  	@poll = Poll[params[:id]]
  	redirect '/' unless @poll
  	redirect '/' unless params[:token] == @poll.token

	@poll.start

	content_type "application/json"
	erb({status: 'success', seconds_remaining: @poll.seconds_remaining }.to_json, :layout => false)
  end

  get %r{/(\d+)} do |id|
  	@poll = Poll[id]
  	redirect '/' unless @poll

  	@owner = session[:tokens] && session[:tokens].include?(@poll.token)
    erb :poll
  end

  post '/vote/:poll_id/:answer_id' do
  	@poll = Poll[params[:poll_id]]
  	redirect '/' unless @poll

  	Vote.create poll: @poll, answer: Answer[params[:answer_id]]

  	# TODO: DON'T DO THIS HERE!!
    client = Faye::Client.new('http://localhost:9292/fayex')
    client.publish('/messages', {'poll_id' => @poll.id, 'status' => 'counts'}.merge(@poll.counts) )

  	content_type "application/json"
	erb({ status: 'success' }.to_json, :layout => false)
  end

end