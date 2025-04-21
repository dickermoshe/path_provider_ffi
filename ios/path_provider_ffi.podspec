#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint path_provider_ffi.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'path_provider_ffi_foundation'
  s.version          = '0.0.1'
  s.summary          = 'An iOS and macOS implementation of the path_provider_ffi plugin.'
  s.description      = <<-DESC
An iOS and macOS implementation of the path_provider_ffi plugin.
This plugin is only used to ensure that the path_provider_ffi plugin is
compatible with iOS and macOS.
                       DESC
  s.homepage         = 'https://github.com/dickermoshe/path_provider_ffi'
  s.license          = { :type => 'BSD', :file => '../LICENSE' }
  s.author           = { 'Flutter Dev Team' => 'flutter-dev@googlegroups.com', 'Moshe Dicker' => 'dickermoshe@gmail.com' }

  # This will ensure the source files in Classes/ are included in the native
  # builds of apps using this FFI plugin. Podspec does not support relative
  # paths, so Classes contains a forwarder C file that relatively imports
  # `../src/*` so that the C sources can be shared among all target platforms.
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'
  s.ios.deployment_target = '12.0'
  s.osx.deployment_target = '10.14'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
