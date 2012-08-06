class PathwayViewController < UIViewController
  attr_accessor :pathway, :buttonView, :currentEnzyme

  def loadView
    self.view = PathwayView.alloc.init
  end

  def viewDidLoad
    self.title = pathway.name
    self.view.delegate = self

    becomeFirstResponder

    gestureRecognizer = UITapGestureRecognizer.alloc.initWithTarget(self, action:'handleDoubleTap:')
    gestureRecognizer.numberOfTapsRequired = 2
    view.addGestureRecognizer(gestureRecognizer)
  end

  def viewDidAppear(animated)
    MBProgressHUD.showHUDAddedTo(view, animated:true)
    BW::HTTP.get(BASE_URL + "pathways/#{pathway.key}") do |response|
      if response.ok?
        pathway.enzymes = BW::JSON.parse(response.body.to_str)

        BW::HTTP.get(BASE_URL + "/pathways/#{pathway.key}.png") do |res|
          if res.ok?
            view.imageView = res.body
            addButtons
            self.view.zoomScale = view.minimumZoomScale
            MBProgressHUD.hideHUDForView(view, animated:true)
          else
            warn "Error while downloading pathway image"
          end
        end
      else
        warn "Error while downloading enzymes"
      end
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
    App.open_url "http://www.genome.jp/dbget-bin/www_bget?" + currentEnzyme.key
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

  def addButtons
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

  # UIMenuController
  def canBecomeFirstResponder
    true
  end

  def canPerformAction(action, withSender:sender)
    action.to_s == 'openDetailView'
  end

  def shouldAutorotateToInterfaceOrientation(interfaceOrientation)
    interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown
  end
end
