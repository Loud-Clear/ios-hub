#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ComponentsHub"
  s.version      = "0.0.1"
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

end
