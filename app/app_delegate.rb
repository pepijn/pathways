BASE_URL = "http://metabomap.herokuapp.com/"

class AppDelegate
  attr_accessor :navigationController, :data, :doc

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = self.navigationController
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible

    true
  end

  def navigationController
    @navigationController ||= UINavigationController.alloc.initWithRootViewController(MasterViewController.alloc.init)
  end
end
