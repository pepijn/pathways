# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'motion-cocoapods'
require 'motion-testflight'
require 'bubble-wrap'

Motion::Project::App.setup do |app|
  app.name = 'Pathways'
  app.identifier = 'nl.plict.Metabomap'
  app.short_version = '0.3.0'
  app.version = '0.3.0'
  app.device_family = [:iphone, :ipad]

  app.icons += %w(icon.png icon@2x.png)

  app.pods do
    pod 'MBProgressHUD'
  end

  app.codesign_certificate = 'iPhone Distribution: Pepijn Looije'
  app.provisioning_profile = '/Users/pepijn/Desktop/TestFlight_15_aug.mobileprovision'

  app.testflight.sdk = 'vendor/TestFlightSDK'
  app.testflight.api_token = '80c1607f35a1ef3c3b9acd9a5181b059_MjU0NDU5MjAxMS0xMi0xOSAxMTo1NToxNi4wNzgxODY'
  app.testflight.team_token = '5b5c06e258622c152fae85fadd19a0e3_NzM5MzEyMDEyLTAzLTIyIDA2OjI5OjE3LjU0ODEwOQ'
end
