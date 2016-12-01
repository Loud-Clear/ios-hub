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

  s.subspec 'Observation' do |subspec|
      subspec.source_files   = 'Components/Observing/**/*.{h,m}'
      subspec.dependency 'KVOController'
      subspec.dependency 'ComponentsHub/Macroses'
      subspec.dependency 'Typhoon'
  end
  
  s.subspec 'Macroses' do |subspec|
      subspec.source_files   = 'Components/Macroses/**/*.{h,m}'
      subspec.dependency 'libextobjc/EXTScope'
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
  
  s.subspec 'TopmostViewController' do |subspec|
      subspec.source_files   = 'Components/TopmostViewController/**/*.{h,m}'
  end
  
  s.subspec 'NotificationUtils' do |subspec|
      subspec.source_files   = 'Components/NotificationUtils/**/*.{h,m}'
      subspec.dependency 'Typhoon/DeallocNotifier'
  end

  s.subspec 'MutableCollections' do |subspec|
      subspec.source_files   = 'Components/MutableCollections/**/*.{h,m}'
  end
  
  s.subspec 'MapCollections' do |subspec|
      subspec.source_files   = 'Components/MapCollections/**/*.{h,m}'
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
  
  s.subspec 'Table' do |subspec|
      subspec.source_files   = 'Components/Table/**/*.{h,m}'
  end
  
  s.subspec 'Forms' do |subspec|
      subspec.source_files   = 'Components/Forms/**/*.{h,m}'
      subspec.resource_bundle = { 'CCTableViewManager' => 'Components/Forms/Resources/*' }
      subspec.preserve_paths = 'Components/Forms/Resources'
      
      subspec.dependency 'ComponentsHub/Table'
  end

  # Categories

  s.subspec 'UIColor+Hex' do |subspec|
      subspec.source_files = 'Components/Categories/UIColor+Hex.{h,m}'
  end

end
