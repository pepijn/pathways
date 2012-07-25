class DetailViewController < UITableViewController
  attr_accessor :enzyme

  def viewDidLoad
    self.title = enzyme.key

    tableView.delegate = self
    tableView.dataSource = self
  end

  def numberOfSectionsInTableView(tableView)
    1
  end

  def tableView(tableView, numberOfRowsInSection:section)
    1
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier("Cell") ||
      UITableViewCell.alloc.initWithStyle(UITableViewCellStyleValue2,
      reuseIdentifier:"Cell")

    cell.textLabel.text = enzyme.key
    cell.detailTextLabel.text = "Name"
    cell
  end
end
