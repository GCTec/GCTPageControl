
Pod::Spec.new do |s|
  s.name         = "GCTPageControl"
  s.version      = "0.0.1"
  s.summary      = "自定义 pageControl for animated"
  s.description  = <<-DESC
  自定义 pageControl for animated：
  支持 系统方式pageControl；
  支持 动画的pageControl；
  支持 支持自定义的pageControl
                   DESC

  s.homepage     = "https://github.com/GCTec/GCTPageControl"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "Later" => "lshxin89@126.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/GCTec/GCTPageControl.git", :tag => s.version }
  s.frameworks = 'UIKit', 'Foundation'
  s.requires_arc = true

  s.public_header_files = 'GCTPageControl/*.h'
  s.source_files = 'GCTPageControl/*.{h,m}'
end
