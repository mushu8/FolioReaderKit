Pod::Spec.new do |s|
  s.name             = "FolioReaderKit"
  s.version          = "1.1.0"
  s.summary          = "A fork of FolioReaderKit to integrate properly custom fonts"
  s.description  = <<-DESC
                   Written in Swift.
                   The Best Open Source ePub Reader.
                   DESC
  s.homepage         = "https://github.com/mushu8/FolioReaderKit"
  s.license          = 'BSD'
  s.author           = { "Alexandre Sagette" => "sagette.alexandre@gmail.com" }
  s.source           = { :git => "https://github.com/mushu8/FolioReaderKit", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = [
    'Source/*.{h,swift}',
    'Source/**/*.swift',
    'Vendor/**/*.swift',
	'CommonCrypto/*.{h,m}',
  ]
  s.resources = [
    'Source/**/*.{js,css}',
    'Source/Resources/*.xcassets',
    'Source/Resources/Fonts/**/*.{otf,ttf}'
  ]
  s.public_header_files = 'Source/*.h', 'CommonCrypto/*.h'

  s.xcconfig = { 'SWIFT_INCLUDE_PATHS' =>'$(PODS_ROOT)/CommonCrypto/iphoneos.modulemap' }
  s.preserve_paths = 'CommonCrypto/iphoneos.modulemap'

  s.libraries  = "z"
  s.dependency 'SSZipArchive', '~> 1.6'
  s.dependency 'MenuItemKit', '2.0'
  s.dependency 'ZFDragableModalTransition', '~> 0.6'
  s.dependency 'AEXML', '4.0'
  s.dependency 'FontBlaster', '3.0.0'
  s.dependency 'JSQWebViewController', '~> 5.0'
  s.dependency 'RealmSwift', '~> 2.1'

end
