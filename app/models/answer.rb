class Answer < Ohm::Model
  attribute :text
  reference :poll, :Poll
  collection :votes, :Vote

  def validate
  	assert_present :text
  end
end