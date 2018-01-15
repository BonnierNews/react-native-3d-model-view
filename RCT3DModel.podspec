
require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|

  s.name           = 'RCT3DModel'
  s.version        = package['version']
  s.summary        = package['description']
  s.author         = package['author']
  s.license        = package['license']
  s.homepage       = 'https://github.com/BonnierNews/react-native-3d-model-view'
  s.source         = { :git => 'https://github.com/BonnierNews/react-native-3d-model-view.git', :tag => "#{s.version}"}
  s.platform       = :ios, '8.0'
  s.preserve_paths = '*.js'
  s.library        = 'z'

  s.dependency 'React'

  s.subspec 'Core' do |ss|
    ss.source_files = 'ios/*.{h,m}'
    ss.public_header_files = ['ios/RCT3DModelView.h']
  end

  s.subspec 'SSZipArchive' do |ss|
    ss.source_files = 'ios/SSZipArchive/*.{h,m}', 'ios/SSZipArchive/aes/*.{h,c}', 'ios/SSZipArchive/minizip/*.{h,c}'
    ss.private_header_files = 'ios/SSZipArchive/*.h', 'ios/SSZipArchive/aes/*.h', 'ios/SSZipArchive/minizip/*.h'
  end

  s.subspec 'AFNetworking' do |ss|
    ss.source_files = 'ios/AFNetworking/*.{h,m}'
    ss.private_header_files = 'ios/AFNetworking/*.h'
  end

end
