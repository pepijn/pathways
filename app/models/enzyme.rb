class Enzyme
  attr_accessor :key, :frame

  def initialize(entry)
    self.key = entry['key']
    self.frame = entry['frame']
  end
end
