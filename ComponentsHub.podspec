#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ComponentsHub"
  s.version      = "0.0.2"
  s.summary      = "A short description of ComponentsHub."
  s.description  = "Shared components for iOS projects"

  s.homepage     = "https://github.com/Loud-Clear/ios-hub.git"

  s.license      = "Proprietary"

  s.author             = { "Aleksey Garbarev" => "aleksey.garbarev@loudclear.com.au" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "git@github.com:Loud-Clear/ios-hub.git", :tag => "#{s.version}" }
  s.source_files  = "Components", "Components/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"

  #
  # Let's keep sub-components sorted alphabetically (by folder structure).
  #

  # Categories dir

  s.subspec 'UIColor+Hex' do |subspec|
      subspec.source_files = 'Components/Categories/UIColor+Hex.{h,m}'
  end

  s.subspec 'NSString+SHA1' do |subspec|
      subspec.source_files = 'Components/Categories/NSString+SHA1.{h,m}'
  end

  s.subspec 'DispatchUtils' do |subspec|
      subspec.source_files = 'Components/DispatchUtils/**/*.{h,m}'
  end

  s.subspec 'Forms' do |subspec|
      subspec.source_files   = 'Components/Forms/**/*.{h,m}'
      subspec.resource_bundle = { 'CCTableViewManager' => 'Components/Forms/Resources/*' }
      subspec.preserve_paths = 'Components/Forms/Resources'

      subspec.dependency 'ComponentsHub/Table'
      subspec.dependency 'ComponentsHub/Observation'
  end

  s.subspec 'ImageService-Common' do |subspec|
      subspec.source_files   = 'Components/ImageService/CCImageService.h', 'Components/ImageService/UIImageView+CCImageService/*.{h,m}'
      subspec.dependency 'ComponentsHub/Macroses'
      subspec.dependency 'Typhoon'
  end

  s.subspec 'ImageService-AFNetworking' do |subspec|
      subspec.source_files   = 'Components/ImageService/Implementations/AFNetworking/*.{h,m}'
      subspec.dependency 'ComponentsHub/ImageService-Common'
      subspec.dependency 'AFNetworking'
  end

  s.subspec 'ImageService-SDWebImage' do |subspec|
      subspec.source_files   = 'Components/ImageService/Implementations/SDWebImage/*.{h,m}'
      subspec.dependency 'ComponentsHub/ImageService-Common'
      subspec.dependency 'SDWebImage'
  end

  s.subspec 'ImageService-Custom' do |subspec|
      subspec.source_files   = 'Components/ImageService/Implementations/AFNetworking/*.{h,m}'
      subspec.dependency 'ComponentsHub/ImageService-Common'
      subspec.dependency 'ComponentsHub/DispatchUtils'
      subspec.dependency 'ComponentsHub/NSString+SHA1'
      subspec.dependency 'PINCache'
      subspec.dependency 'libextobjc/EXTScope'
      subspec.dependency 'ComponentsHub/Macroses'
  end

  s.subspec 'Macroses' do |subspec|
      subspec.source_files   = 'Components/Macroses/**/*.{h,m}'
      subspec.dependency 'libextobjc/EXTScope'
  end

  s.subspec 'MapCollections' do |subspec|
      subspec.source_files   = 'Components/MapCollections/**/*.{h,m}'
  end

  s.subspec 'MutableCollections' do |subspec|
      subspec.source_files   = 'Components/MutableCollections/**/*.{h,m}'
  end

  s.subspec 'NotificationUtils' do |subspec|
      subspec.source_files   = 'Components/NotificationUtils/**/*.{h,m}'
      subspec.dependency 'Typhoon/DeallocNotifier'
  end

  s.subspec 'Observation' do |subspec|
      subspec.source_files   = 'Components/Observing/**/*.{h,m}'
      subspec.dependency 'KVOController'
      subspec.dependency 'ComponentsHub/Macroses'
      subspec.dependency 'Typhoon/IntrospectionUtils'
  end

  s.subspec 'RoundButton' do |subspec|
        subspec.source_files   = 'Components/RoundButton/**/*.{h,m}'
  end

  s.subspec 'RealmAddons' do |subspec|
      subspec.source_files   = 'Components/RealmAddons/**/*.{h,m}'
      subspec.dependency 'Realm'
      subspec.dependency 'ComponentsHub/Observation'
  end

  s.subspec 'SingletoneStorage' do |subspec|
      subspec.source_files   = 'Components/SingletoneStorage/**/*.{h,m}'
      subspec.dependency 'FastCoding'
      subspec.dependency 'SAMKeychain'
      subspec.dependency 'ComponentsHub/Macroses'
  end

  s.subspec 'Table' do |subspec|
      subspec.source_files   = 'Components/Table/**/*.{h,m}'
  end
  
  s.subspec 'TopmostViewController' do |subspec|
      subspec.source_files   = 'Components/TopmostViewController/**/*.{h,m}'
  end

  s.subspec 'TyphoonAddons' do |subspec|
      subspec.source_files   = 'Components/TyphoonAddons/**/*.{h,m}'
      subspec.dependency 'Typhoon'
  end

  s.subspec 'VIPER' do |subspec|
      subspec.source_files   = 'Components/VIPER/**/*.{h,m}'
      subspec.dependency 'Typhoon'
      subspec.dependency 'MTAnimation'
      subspec.dependency 'CTObjectiveCRuntimeAdditions'
      subspec.dependency 'ComponentsHub/Macroses'
      subspec.dependency 'ComponentsHub/NotificationUtils'
      subspec.dependency 'ComponentsHub/MutableCollections'
      subspec.dependency 'ComponentsHub/MapCollections'
  end

end
