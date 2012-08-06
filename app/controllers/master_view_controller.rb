class MasterViewController < UITableViewController
  attr_accessor :categories

  def viewDidLoad
    self.title = App.name

    tableView.delegate = self
    tableView.dataSource = self

    self.categories = []
  end

  def viewDidAppear(animated)
    if categories.empty?
      MBProgressHUD.showHUDAddedTo(view, animated:true)

      BubbleWrap::HTTP.get(BASE_URL + "pathways") do |response|
        if response.ok?
          BW::JSON.parse(response.body.to_str).each do |entry|
            categories << Category.new(entry)
          end

          tableView.reloadData
          MBProgressHUD.hideHUDForView(view, animated:true)
        else
          warn "Error while downloading pathways"
        end
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
    controller = PathwayViewController.alloc.init
    controller.pathway = pathway
    navigationController.pushViewController(controller, animated:true)
  end
end
