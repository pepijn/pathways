class PathwayViewController < UIViewController
  attr_accessor :pathway, :buttonView, :currentEnzyme

  def loadView
    self.view = PathwayView.alloc.init
    view.imageView = pathway.imagePath
  end

  def viewDidLoad
    self.title = pathway.name
    self.view.contentSize = view.imageView.frame.size
    self.view.delegate = self

    becomeFirstResponder

    gestureRecognizer = UITapGestureRecognizer.alloc.initWithTarget(self, action:'handleDoubleTap:')
    gestureRecognizer.numberOfTapsRequired = 2
    view.addGestureRecognizer(gestureRecognizer)

    self.buttonView = UIView.alloc.initWithFrame(CGRectApplyAffineTransform(view.imageView.frame, CGAffineTransformMakeTranslation(-23, -9)))
    view.imageView.addSubview(buttonView)

    pathway.enzymes.each.with_index do |enzyme, index|
      button = UIButton.buttonWithType(UIButtonTypeCustom)
      button.frame = enzyme.frame
      button.tag = index
      button.addTarget(self, action:'showMenuController:', forControlEvents:UIControlEventTouchDown)
      buttonView.addSubview(button)
    end
  end

  def showMenuController(sender)
    self.currentEnzyme = pathway.enzymes[sender.tag]

    menu = UIMenuController.sharedMenuController
    menu.menuItems = [UIMenuItem.alloc.initWithTitle(currentEnzyme.name,
      action:'openDetailView')]
    menu.setTargetRect(sender.frame, inView:buttonView)
    menu.setMenuVisible(true, animated:true)
  end

  def openDetailView
    controller = DetailViewController.alloc.initWithStyle(UITableViewStyleGrouped)
    controller.enzyme = currentEnzyme
    navigationController.pushViewController(controller, animated:true)
  end

  def viewWillAppear(animated)
    self.view.zoomScale = view.minimumZoomScale

    super
  end

  def viewForZoomingInScrollView(view)
    self.view.imageView
  end

  def scrollViewDidEndZooming(scrollView, withView:view, atScale:scale)
  end

  def handleDoubleTap(gestureRecognizer)
    if view.zoomScale < 1
      point = gestureRecognizer.locationInView(view.imageView)
      view.zoomToRect([point, [100, 100]], animated:true)
    else
      view.setZoomScale(view.minimumZoomScale, animated:true)
    end
  end

  # UIMenuController
  def canBecomeFirstResponder
    true
  end

  def canPerformAction(action, withSender:sender)
    action.to_s == 'openDetailView'
  end
end
