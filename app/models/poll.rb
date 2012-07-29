class Poll < Ohm::Model
  attribute :question
  attribute :token
  attribute :active
  attribute :visible
  attribute :ip
  attribute :started_at
  attribute :ending_at

  list :answers, :Answer
  collection :votes, :Vote

  include Ohm::Callbacks

  def before_create
  	self.token = rand(10 ** 8).to_s(20)
    self.visible = true
    self.active = false
  end

  def active?
    return false if self.active == false || self.active == 'false'
    true
  end

  def validate
  	assert_present :question
  end

  def start
    self.started_at = Time.now.to_i
    self.ending_at = Time.now.to_i + 15
    self.active = true
    self.save
    client = Faye::Client.new('http://localhost:9292/fayex')
    client.publish('/messages', 'status' => 'start', 'seconds_remaining' => self.seconds_remaining, 'poll_id' => self.id)
  end

  def ready_to_start?
    return true unless self.ending_at
    return false if self.ending_at.to_i < Time.now.to_i
    return false if Time.now.to_i > self.started_at.to_i
    true
  end

  def counts
    h = Hash[answers.to_a.map { |a| ["answer-#{a.id}", votes.count { |v| v.answer_id == a.id }] }]
    h['max'] = h.values.max
    h['total'] = self.votes.size
    h
  end

  def finished?
    return true if self.ending_at && Time.now.to_i > self.ending_at.to_i
    false
  end

  def finish
    self.active = false
    self.save
  end

  def seconds_remaining
    r = [self.ending_at.to_i - Time.now.to_i, 0].max rescue 0
    finish if r < 1
    r
  end

  def winner
    votes.group_by { |v| v.answer }.max_by { |k, v| v.size }.first
  end
end