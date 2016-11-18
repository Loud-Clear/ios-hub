#
#  Be sure to run `pod spec lint ComponentsHub.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ComponentsHub"
  s.version      = "0.0.1"
  s.summary      = "A short description of ComponentsHub."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = "Shared components for iOS projects"

  s.homepage     = "https://github.com/Loud-Clear/ios-hub.git"



  s.license      = "Proprietary"


  s.author             = { "Aleksey Garbarev" => "aleksey.garbarev@loudclear.com.au" }
  # Or just: s.author    = "Aleksey Garbarev"
  # s.authors            = { "Aleksey Garbarev" => "aleksey@appsquick.ly" }
  # s.social_media_url   = "http://twitter.com/Aleksey Garbarev"

  s.platform     = :ios
  
  # s.platform     = :ios, "5.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "git@github.com:Loud-Clear/ios-hub.git", :tag => "#{s.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files  = "Components", "Components/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"
  
  # ――― Subspec ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #


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


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
