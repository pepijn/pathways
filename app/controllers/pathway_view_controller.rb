class PathwayViewController < UIViewController
  attr_accessor :pathway, :buttonView

  def loadView
    self.view = PathwayView.alloc.init
    view.imageView = pathway.imagePath
  end

  def viewDidLoad
    self.title = pathway.name
    self.view.contentSize = view.imageView.frame.size
    self.view.delegate = self

    gestureRecognizer = UITapGestureRecognizer.alloc.initWithTarget(self, action:'handleDoubleTap:')
    gestureRecognizer.numberOfTapsRequired = 2
    view.addGestureRecognizer(gestureRecognizer)

    self.buttonView = UIView.alloc.initWithFrame(CGRectApplyAffineTransform(view.imageView.frame, CGAffineTransformMakeTranslation(-23, -9)))
    view.imageView.addSubview(buttonView)

    pathway.enzymes.each.with_index do |enzyme, index|
      button = UIButton.buttonWithType(UIButtonTypeCustom)
      button.frame = enzyme.frame
      button.tag = index
      button.addTarget(self, action:'openDetailView:', forControlEvents:UIControlEventTouchDown)
      buttonView.addSubview(button)
    end
  end

  def openDetailView(sender)
    controller = DetailViewController.alloc.initWithStyle(UITableViewStyleGrouped)
    controller.enzyme = pathway.enzymes[sender.tag]
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
end
