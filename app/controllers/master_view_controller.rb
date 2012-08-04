class MasterViewController < UITableViewController
  attr_accessor :categories

  def viewDidLoad
    self.title = App.name

    tableView.delegate = self
    tableView.dataSource = self

    self.categories = []
    BubbleWrap::HTTP.get("http://pathways.dev/pathways") do |response|
      if response.ok?
        BW::JSON.parse(response.body.to_str).each do |entry|
          categories << Category.new(entry)
        end

        tableView.reloadData
      else
        warn "Error while downloading pathways"
      end
    end
  end

  def numberOfSectionsInTableView(tableView)
    categories.size
  end

  def tableView(tableView, titleForHeaderInSection:section)
    categories[section].name
  end

  def tableView(tableView, numberOfRowsInSection:section)
    categories[section].pathways.size
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier("Cell") ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault,
      reuseIdentifier:"Cell")

    cell.textLabel.text = categories[indexPath.section].pathways[indexPath.row].name
    # cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    pathway = categories[indexPath.section].pathways[indexPath.row]

    BW::HTTP.get("http://pathways.dev/maps/#{pathway.key}") do |response|
      if response.ok?
        pathway.enzymes = BW::JSON.parse(response.body.to_str)

        controller = PathwayViewController.alloc.init
        controller.pathway = pathway

        if NSFileManager.defaultManager.fileExistsAtPath(pathway.imagePath)
          pushToController(controller)
        else
          BW::HTTP.get("http://rest.kegg.jp/get/#{pathway.key}/image") do |res|
            if res.ok?
              res.body.writeToFile(pathway.imagePath, atomically:true)
              pushToController(controller)
            else
              warn "Error while downloading pathway image"
            end
          end
        end
      else
        warn "Error while downloading enzymes"
      end
    end
  end

  def pushToController(controller)
    navigationController.pushViewController(controller, animated:true)
  end
end
