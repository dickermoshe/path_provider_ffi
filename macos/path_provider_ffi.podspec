#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint path_provider_ffi.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'path_provider_ffi_macos'
  s.version          = '0.0.1'
  s.summary          = 'An iOS implementation of the path_provider_ffi plugin.'
  s.description      = <<-DESC
An macOS implementation of the path_provider_ffi plugin.
This plugin is only used to ensure that the path_provider_ffi plugin is
compatible with macOS.
                       DESC
                       s.homepage         = 'https://github.com/dickermoshe/path_provider_ffi'
                       s.license          = { :type => 'BSD', :file => '../LICENSE' }
                       s.author           = { 'Flutter Dev Team' => 'flutter-dev@googlegroups.com', 'Moshe Dicker' => 'dickermoshe@gmail.com' }
                     s.source           = { :path => '.' }
                       s.source_files = 'Classes/**/*'
  s.source_files = 'Classes/**/*'
  s.dependency 'FlutterMacOS'
  s.platform = :osx, '10.14'
  s.swift_version = '5.0'
end
