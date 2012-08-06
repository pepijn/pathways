get '/pathways' do
  content_type :json

  keys = []
  open('http://rest.kegg.jp/list/pathway').each do |line|
    line = line.split(' ')
    keys << line.shift #.gsub('path:map', 'ec')
  end

  # Artificial limit
  keys = keys[0..100]

  pathways = []
  API_LIMIT = 10
  (keys.size / API_LIMIT).ceil.times.each do |offset|
    offset *= API_LIMIT

    open('http://rest.kegg.jp/get/' + keys[offset..(offset + API_LIMIT)].join('+')) do |f|
      f.read.split('///').each do |entry|
        next if entry.chomp.empty?

        pathway = Bio::KEGG::PATHWAY.new(entry)
        pathways << {
          key: pathway.entry_id.gsub('map', 'ec'),
          name: pathway.name,
          category: pathway.keggclass.gsub('Metabolism; ', '')
        }
      end
    end
  end

  categories = []
  pathways.each do |pathway|
    category = categories.select {|c| c[:name] == pathway[:category] }.first

    unless category
      category = {
        name: pathway[:category],
        pathways: []
      }
      categories << category
    end

    category[:pathways] << pathway
  end

  categories.to_json
end

get '/pathways/:entry.png' do
  content_type :png
  url = "http://rest.kegg.jp/get/#{params[:entry]}/image"
  puts url
  open "http://rest.kegg.jp/get/#{params[:entry]}/image" do |file|
    file.read
  end
end

get "/pathways/:entry" do
  content_type :json
  enzymes = []
  entry = params[:entry]
  url = "http://www.genome.jp/kegg-bin/download?format=kgml&entry=" + entry

  # Parse XML
  open(url) do |file|
    doc = Nokogiri.XML file

    for enzyme in doc.xpath('/pathway/entry[@type="enzyme"]/graphics') do
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
