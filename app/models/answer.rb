class Answer < Ohm::Model
  attribute :text
  reference :poll, :Poll

  def validate
  	assert_present :text
  end
end