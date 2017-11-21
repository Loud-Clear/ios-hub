#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ComponentsHub"
  s.version      = "0.0.5"
  s.summary      = "A short description of ComponentsHub."
  s.description  = "Shared components for iOS projects"

  s.homepage     = "https://github.com/Loud-Clear/ios-hub.git"

  s.license      = "Proprietary"

  s.author       = { "Aleksey Garbarev" => "aleksey.garbarev@loudclear.com.au" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "git@github.com:Loud-Clear/ios-hub.git", :tag => "#{s.version}" }
  s.source_files  = "Components", "Components/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"

  #
  # Let's keep sub-components sorted alphabetically (by folder structure).
  #

  # Categories dir

  s.subspec 'BaseObjects' do |subspec|
      subspec.source_files = 'Components/BaseObjects/**/*.{h,m}'
  end

  s.subspec 'BlockHandler' do |subspec|
      subspec.source_files = 'Components/BlockHandler/**/*.{h,m}'
      subspec.dependency 'ComponentsHub/Macroses'
      subspec.dependency 'Typhoon'
  end

  s.subspec 'Categories' do |subspec|
      subspec.source_files = 'Components/Categories/**/*.{h,m}'
      subspec.dependency 'ComponentsHub/Macroses'
      subspec.dependency 'ComponentsHub/ManualLayout'
  end

  s.subspec 'UIColor+Hex' do |subspec|
      subspec.source_files = 'Components/Categories/UIColor+Hex.{h,m}'
  end

  s.subspec 'NSString+SHA1' do |subspec|
      subspec.source_files = 'Components/Categories/NSString+SHA1.{h,m}'
  end

  s.subspec 'DispatchUtils' do |subspec|
      subspec.source_files = 'Components/DispatchUtils/**/*.{h,m}'
  end

  s.subspec 'FeatheredScrollView' do |subspec|
      subspec.source_files = 'Components/FeatheredScrollView/**/*.{h,m}'
      subspec.dependency 'EGOGradientView'
  end

  s.subspec 'Forms' do |subspec|
      subspec.source_files   = 'Components/Forms/**/*.{h,m}'
      subspec.resource_bundle = { 'CCTableViewManager' => 'Components/Forms/Resources/*' }
      subspec.preserve_paths = 'Components/Forms/Resources'

      subspec.dependency 'ComponentsHub/Table'
      subspec.dependency 'ComponentsHub/Observation'
  end

  s.subspec 'Environment' do |subspec|
      subspec.source_files   = 'Components/Environment/**/*.{h,m}'
      subspec.dependency 'BaseModel'
      subspec.dependency 'ComponentsHub/SingletonStorage'
      subspec.dependency 'ComponentsHub/Macroses'
  end

    s.subspec 'EnvironmentUI' do |subspec|
        subspec.source_files   = 'Components/EnvironmentUI/**/*.{h,m}'
        subspec.dependency 'ComponentsHub/Environment'
        subspec.dependency 'ComponentsHub/Forms'
        subspec.dependency 'ComponentsHub/ManualLayout'
        subspec.dependency 'ComponentsHub/NotificationUtils'
        subspec.dependency 'ComponentsHub/Observation'
        subspec.dependency 'ComponentsHub/StatusBarHUD'
        subspec.dependency 'PureLayout'
        subspec.dependency 'TPKeyboardAvoiding'
        subspec.dependency 'Typhoon/IntrospectionUtils'
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
      subspec.dependency 'SDWebImage', '~> 3.0'
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

  s.subspec 'Logging' do |subspec|
      subspec.source_files   = 'Components/Logging/**/*.{h,m}'
      subspec.dependency 'BugfenderSDK/ObjC', '~> 1.4'
      subspec.dependency 'CocoaLumberjack'
  end

  s.subspec 'Macroses' do |subspec|
      subspec.source_files   = 'Components/Macroses/**/*.{h,m}'
      subspec.dependency 'libextobjc/EXTScope'
  end
 
  s.subspec 'ManualLayout' do |subspec|
      subspec.source_files   = 'Components/ManualLayout/**/*.{h,m}'
  end

  s.subspec 'MapCollections' do |subspec|
      subspec.source_files   = 'Components/MapCollections/**/*.{h,m}'
  end

  s.subspec 'MutableCollections' do |subspec|
      subspec.source_files   = 'Components/MutableCollections/**/*.{h,m}'
  end

  s.subspec 'NetworkAddons' do |subspec|
      subspec.source_files   = 'Components/NetworkAddons/**/*.{h,m}'
      subspec.dependency 'TyphoonRestClient'
  end

  s.subspec 'NotificationUtils' do |subspec|
      subspec.source_files   = 'Components/NotificationUtils/**/*.{h,m}'
      subspec.dependency 'Typhoon/DeallocNotifier'
  end

  s.subspec 'Observation' do |subspec|
      subspec.source_files   = 'Components/Observing/**/*.{h,m}'
      subspec.dependency 'KVOController'
      subspec.dependency 'ComponentsHub/Macroses'
  end

  s.subspec 'RoundButton' do |subspec|
      subspec.source_files   = 'Components/RoundButton/**/*.{h,m}'
  end

  s.subspec 'Shorthands' do |subspec|
      subspec.source_files   = 'Components/Shorthands/**/*.{h,m}'
      subspec.dependency 'NSAttributedString+CCLFormat'
  end

  s.subspec 'RealmAddons' do |subspec|
      subspec.source_files   = 'Components/RealmAddons/**/*.{h,m}'
      subspec.dependency 'Realm'
      subspec.dependency 'ComponentsHub/Observation'
      subspec.dependency 'ComponentsHub/NotificationUtils'
  end

  s.subspec 'RemoteNotificationsService' do |subspec|
      subspec.source_files   = 'Components/RemoteNotificationsService/**/*.{h,m}'
      subspec.dependency 'ComponentsHub/SingletonStorage'
      subspec.dependency 'ComponentsHub/NotificationUtils'
      subspec.dependency 'ComponentsHub/Macroses'
  end

  s.subspec 'SingletonStorage' do |subspec|
      subspec.source_files   = 'Components/SingletonStorage/**/*.{h,m}'
      subspec.dependency 'FastCoding'
      subspec.dependency 'SAMKeychain'
      subspec.dependency 'ComponentsHub/Macroses'
  end

  s.subspec 'StatusBarHUD' do |subspec|
      subspec.source_files   = 'Components/StatusBarHUD/**/*.{h,m}'
      subspec.dependency 'ComponentsHub/Macroses'
      subspec.dependency 'PureLayout'
      subspec.dependency 'ComponentsHub/NotificationUtils'
  end

  s.subspec 'Table' do |subspec|
      subspec.source_files   = 'Components/Table/**/*.{h,m}'
  end

  s.subspec 'TestUtils' do |subspec|
      subspec.source_files   = 'Components/TestUtils/**/*.{h,m}'
      subspec.framework = 'XCTest'
  end
  
  s.subspec 'TopmostViewController' do |subspec|
      subspec.source_files   = 'Components/TopmostViewController/**/*.{h,m}'
  end

  s.subspec 'TRCAddons' do |subspec|
    subspec.source_files   = 'Components/TRCAddons/**/*.{h,m}'
    subspec.dependency 'TyphoonRestClient'
  end
  
  s.subspec 'TRCRealm' do |subspec|
      subspec.source_files   = 'Components/TRCRealm/**/*.{h,m}'
      subspec.dependency 'TyphoonRestClient'
      subspec.dependency 'ComponentsHub/RealmAddons'
      subspec.dependency 'ComponentsHub/MutableCollections'
      subspec.dependency 'ComponentsHub/NetworkAddons'
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
