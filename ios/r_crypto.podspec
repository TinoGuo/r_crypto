#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint r_crypto.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'r_crypto'
  s.version          = '0.2.0'
  s.summary          = 'Rust backend support crypto library.'
  s.description      = <<-DESC
Rust backend support crypto library.
                       DESC
  s.homepage         = 'https://github.com/TinoGuo/r_crypto'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'Tino' }
  s.source           = { :path => '.' }
  s.public_header_files = 'Classes**/*.h'
  s.source_files = 'Classes/**/*'
  s.static_framework = true
  s.vendored_libraries = "**/*.a"
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
