class Vote < Ohm::Model
  attribute :ip
  reference :poll, :Poll
  reference :answer, :Answer
end