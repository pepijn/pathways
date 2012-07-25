class Pathway
  attr_accessor :key, :name, :enzymes

  def initialize(entry)
    self.key = entry['key']
    self.name = entry['name']
    self.enzymes = (entry['enzymes'] || []).map {|entry| Enzyme.new(entry) }
  end

  def imagePath
    [App.documents_path, '/', key, '.png'].join
  end
end
