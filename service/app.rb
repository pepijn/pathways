get '/pathways' do
  keys = []
  open('http://rest.kegg.jp/list/pathway').each do |line|
    line = line.split(' ')
    keys << line.shift #.gsub('path:map', 'ec')
  end

  keys = keys[0..20]
  raise keys.to_s

  pathways = []
  API_LIMIT = 10
  (keys.size / API_LIMIT).ceil.times do |index|
    open('http://rest.kegg.jp/get/' + keys[(index * API_LIMIT)..API_LIMIT].join('+')) do |f|
      f.read.split('///').each do |entry|
        next if entry.chomp.empty?
        pathways << Bio::KEGG::PATHWAY.new(entry)
      end
    end
  end

  categories = []
  for pathway in pathways do
    if !categories.last || categories.last[:name] != pathway.keggclass
      categories << {
        name: pathway.keggclass.gsub('Metabolism; ', ''),
        pathways: []
      }
    end

    categories.last[:pathways] << {
      key: pathway.entry_id,
      name: pathway.name,
      #enzymes: enzymes
    }
  end

  categories.to_json
end