class Willy
  post '/vote' do
  	question = params[:question]
  	answers = params[:answer]

  	poll = Poll.create question: question, ip: request.ip

  	answers.each do |answer|
  	  poll.answers.push Answer.create text: answer
  	end

  	redirect "#{poll.id}"
  end
end