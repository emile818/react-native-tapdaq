require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-tapdaq"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = { "GieMik8" => "giemik8@email.com" }
  s.platforms    = { :ios => "9.0" }
  s.source       = { :git => "https://github.com/GieMik8/react-native-tapdaq.git", :tag => "#{package["version"]}" }

  s.source_files = "ios/**/*.{h,m,swift}"
  s.requires_arc = true

  s.dependency "React"
  s.dependency "Tapdaq"
end

