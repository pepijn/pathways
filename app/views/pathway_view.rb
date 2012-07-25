class PathwayView < UIScrollView
  attr_accessor :imageView

  def init
    super
  end

  def imageView=(path)
    image = UIImage.imageWithContentsOfFile(path)
    @imageView = UIImageView.alloc.initWithImage(image)
    imageView.userInteractionEnabled = true
    addSubview(imageView)

    orientationHeight = Device.screen.height_for_orientation(Device.orientation)
    self.minimumZoomScale = orientationHeight / image.size.height

    imageView
  end
end
