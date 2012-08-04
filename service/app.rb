get "/maps/:entry" do
  enzymes = []
  entry = params[:entry]
  url = "http://www.genome.jp/kegg-bin/download?entry=#{entry}&format=kgml"

  # Parse XML
  open(url) do |file|
    doc = Nokogiri.XML file

    for enzyme in doc.xpath('//entry[@type="enzyme"]/graphics') do
      enzymes << {
        key: enzyme['name'],
        frame: [[enzyme['x'], enzyme['y']], [enzyme['width'], enzyme['height']]]
      }
    end
  end

  # Parse API
  url = 'http://rest.kegg.jp/list/' + enzymes.map {|e| e[:key] }.join('+')
  open(url).each.with_index do |line, index|
    enzymes[index][:name] = line.split(/[\t;]/)[1].chomp
  end

  {
    enzymes: enzymes
  }.to_json
end


get '/pathways' do
  content_type :json

  keys = []
  open('http://rest.kegg.jp/list/pathway').each do |line|
    line = line.split(' ')
    keys << line.shift #.gsub('path:map', 'ec')
  end

  keys = keys[0..20]

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
    keggclass = pathway.keggclass.gsub('Metabolism; ', '')
    if !categories.last || categories.last[:name] != keggclass
      categories << {
        name: keggclass,
        pathways: []
      }
    end

    categories.last[:pathways] << {
      key: pathway.entry_id.gsub('map', 'ec'),
      name: pathway.name
    }
  end

  categories.to_json
end
