class Category
  attr_accessor :name, :pathways

  def initialize(entry)
    self.name = entry['name'].gsub 'Metabolism; ', ''
    self.pathways = entry['pathways'].map {|entry| Pathway.new(entry) }
  end
end
