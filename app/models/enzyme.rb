class Enzyme
  attr_accessor :key, :name, :frame

  def initialize(entry)
    self.key = entry['key']
    self.name = entry['name']
    self.frame = entry['frame']
  end
end
