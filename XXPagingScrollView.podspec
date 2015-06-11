Pod::Spec.new do |s|
  s.name         = "XXPagingScrollView"
  s.version      = "1.0"
  s.summary      = "A UIScrollView wrap that allow to customize paging size. "
  s.screenshots  = "https://github.com/adad184/XXPagingScrollView/raw/master/screenshot.png"
  s.homepage     = "https://github.com/adad184/XXPagingScrollView"
  s.license      = { :type => 'MIT License', :file => 'LICENSE' }
  s.author       = { "adad184" => "adad184@gmail.com" }
  s.source       = { :git => "https://github.com/adad184/XXPagingScrollView.git", :tag => "1.0" }
  s.platform     = :ios, '8.0'
  s.source_files = 'Classes/XXPagingScrollView.{h,m}'
  s.requires_arc = true
end
