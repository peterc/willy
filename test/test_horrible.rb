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

  it "can add votes to a poll" do
  	@poll = Poll.create question: 'Are you happy?'

  	answers = %w{yes no maybe}

  	answers.each do |answer|
  	  @poll.answers.push(Answer.create text: answer)
  	end

  	[0, 1, 2, 0, 0, 1].each do |i|
  	  Vote.create poll: @poll, answer: @poll.answers.to_a[i]
  	end

  	@poll.votes.size.must_equal 6
  	@poll.winner.must_equal @poll.answers.to_a[0]
  	@poll.answers.to_a[0].votes.size.must_equal 3
  end
end