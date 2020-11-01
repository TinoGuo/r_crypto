#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint r_crypto.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'r_crypto'
  s.version          = '0.0.2'
  s.summary          = 'Rust backend support crypto library.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/TinoGuo/r_crypto'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'Tino' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.static_framework = true
  s.vendored_libraries = "**/*.a"
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
