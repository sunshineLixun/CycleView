Pod::Spec.new do |s|
  s.name         = "LXScrollViewRunLoop"
  s.version      = "0.1.2"
  s.summary      = "A Cycle ScrollView. support gif ImageView."
  s.homepage     = "https://github.com/sunshineLixun/LXScrollViewRunLoop"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "sunshineLixun" => "1261142605@qq.com" }
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/sunshineLixun/LXScrollViewRunLoop.git", :tag => s.version.to_s }
  s.source_files = "CycleScrollView/LXCycleScrollView/**/*.{h,m}"
  # s.public_header_files = "Classes/**/*.h"
  s.requires_arc = true
  s.frameworks = 'UIKit', 'CoreFoundation', 'QuartzCore', 'AssetsLibrary', 'ImageIO', 'Accelerate', 'MobileCoreServices', 'CoreGraphics', 'CoreImage', 'CoreText', 'ImageIO'
  s.dependency "YYWebImage"
  s.dependency "YYCategories"
end