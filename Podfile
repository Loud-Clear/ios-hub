platform :ios, '8.0'

def component(name)
  pod "ComponentsHub/#{name}", :local => "Components/#{name}"
end

target 'iOS Hub' do
  inhibit_all_warnings!

  component 'BaseObjects'
  component 'BlockHandler'
  component 'Categories'
  component 'DispatchUtils'
  component 'Environment'
  component 'EnvironmentUI'
  component 'FeatheredScrollView'
  component 'Forms'
#  component 'ImageService'
  component 'Logging'
  component 'Macroses'
  component 'ManualLayout'
  component 'MapCollections'
  component 'MutableCollections'
  component 'NetworkAddons'
  component 'NotificationUtils'
  component 'Observing'
  component 'RealmAddons'
  component 'RemoteNotificationsService'
  component 'RoundButton'
  component 'Shorthands'
  component 'SingletonStorage'
  component 'StatusBarHUD'
  component 'TRCAddons'
  component 'TRCRealm'
  component 'Table'
  component 'TestUtils'
  component 'TopmostViewController'
  component 'TyphoonAddons'
  component 'VIPER'

  target 'iOS HubTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'OCMock'
  end

end
