Pod::Spec.new do |s|

  s.name         = "WPLibB"
  s.version      = "0.0.1"
  s.summary      = "WPLibB."
  s.description  = "For testing linkage."
  s.homepage     = "https://github.com/Wattpad/WPLibB"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "R. Tony Goold" => "tony@wattpad.com" }
  s.source       = { :git => "https://github.com/Wattpad/WPLibB.git", :tag => s.version.to_s }

  s.platform = :ios, "7.0"
  s.source_files  = "dist/ios/include/WPLibB/*.h"
  s.header_dir = "WPLibB"
  s.preserve_paths = "dist/ios/libWPLibB.a"
  s.ios.vendored_library = "dist/ios/libWPLibB.a"
  s.ios.library = "WPLibB"
  s.requires_arc = true

end
