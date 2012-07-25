require 'json'
require 'open-uri'
require 'nokogiri'
require 'bio'
require 'pathname'

ROOT = Pathname.getwd + 'service'

file = File.open(ROOT + 'pathways.txt')
keys = []

file.each do |line|
  line = line.split(' ')
  keys << line.shift.gsub('path:map', 'ec')
end

pathways = []
all_enzymes = []

open('http://rest.kegg.jp/get/' + keys.join('+')) do |f|
  f.read.split('///').each do |entry|
    next if entry.chomp.empty?
    pathways << Bio::KEGG::PATHWAY.new(entry)
  end
end

categories = []
for pathway in pathways
  if !categories.last || categories.last[:name] != pathway.keggclass
    categories << {
      name: pathway.keggclass,
      pathways: []
    }
  end

  # Download map
  enzymes = []
  entry = pathway.entry_id
  url = "http://www.genome.jp/kegg-bin/download?entry=#{entry}&format=kgml"
  open(url) do |file|
    doc = Nokogiri.XML file

    for enzyme in doc.xpath('//entry[@type="enzyme"]/graphics') do
      puts enzyme
      all_enzymes << enzyme['name']

      enzymes << {
        key: enzyme['name'],
        frame: [[enzyme['x'], enzyme['y']], [enzyme['width'], enzyme['height']]]
      }
    end
  end

  categories.last[:pathways] << {
    key: pathway.entry_id,
    name: pathway.name,
    enzymes: enzymes
  }
end

File.open(ROOT + 'public/pathway.json', 'w') {|f| f.write(pathways.to_json) }

# Enzymes
enzymes = []
open('http://rest.kegg.jp/get/' + all_enzymes.uniq.join('+')) do |f|
  f.read.split('///').each do |entry|
    next if entry.chomp.empty?
    enzymes << Bio::KEGG::ENZYME.new(entry)
  end
end

File.open(ROOT + 'public/enzymes.json', 'w') {|f| f.write(pathways.to_json) }
