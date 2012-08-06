class PathwayView < UIScrollView
  ZOOM_INDEX = 1.2
  attr_accessor :imageView

  def init
    super

    self.backgroundColor = UIColor.whiteColor

    self
  end

  def imageView=(imageData)
    image = UIImage.imageWithData(imageData)
    @imageView = UIImageView.alloc.initWithImage(image)
    imageView.alpha = 0
    imageView.userInteractionEnabled = true
    addSubview(imageView)

    orientationHeight = Device.screen.height_for_orientation(Device.orientation)
    self.minimumZoomScale = orientationHeight / image.size.height * ZOOM_INDEX

    UIView.animateWithDuration(0.3, animations:lambda {
      imageView.alpha = 1
    })

    imageView
  end
end
