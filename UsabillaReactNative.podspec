require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = 'UsabillaReactNative'
  s.version      = package['version']
  s.summary      = package['description']
  s.license      = package['license']

  s.authors      = package['author']
  s.homepage     = package['homepage']
  s.platform     = :ios, "12.0"

  s.swift_version = "4.0"
  s.source       = { :git => "https://github.com/usabilla/usabilla-u4a-react-native.git", :tag => "v#{s.version}" }
  
  s.vendored_frameworks = 'Usabilla.xcframework'
  s.source_files = "ios/**/*.{h,m,swift}"
  s.ios.resource_bundle = { 'Usabilla' => 'Usabilla.xcframework/PrivacyInfo.xcprivacy' }
  s.module_name = 'UsabillaReactNative'

  s.dependency 'React'
  s.dependency 'Usabilla', '~> 6.5'

end
