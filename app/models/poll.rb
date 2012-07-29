class Poll < Ohm::Model
  attribute :question
  attribute :token
  attribute :active
  attribute :ip
  list :answers, :Answer
  set :votes, :Vote

  include Ohm::Callbacks

  def before_create
  	self.token = rand(10 ** 8).to_s(20)
  end

  def validate
  	assert_present :question
  end
end