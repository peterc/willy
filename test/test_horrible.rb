require_relative 'helper'
require 'minitest/spec'
require 'minitest/autorun'

describe "Basic ass tests" do
  after do
    @poll.delete if @poll
  end

  it "can create a poll" do
  	@poll = Poll.create question: 'What is love?'
  	@poll.token.must_match /^\w+$/
  	@poll.id.must_match /^\d+$/
  end

  it "can add answers to a poll" do
  	@poll = Poll.create question: 'What is love?'

  	%w{yes no maybe}.each do |answer|
  	  @poll.answers.push(Answer.create text: answer)
  	end

  	@poll.answers.size.must_equal 3
  end
end