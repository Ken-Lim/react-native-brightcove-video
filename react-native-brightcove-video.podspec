require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-video"
  s.version      = package["version"]
  s.summary      = "A Brightcove <Video /> element for react-native"
  s.author       = "John Clema <john.clema@gmail.com> (https://github.com/JohnClema)"

  s.homepage     = "https://github.com/JohnClema/react-native-brightcove-video"

  s.license      = "MIT"
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/JohnClema/react-native-brightcove-video.git", :tag => "#{s.version}" }

  s.source_files  = "ios/*.{h,m}"

  s.dependency "React"
end
