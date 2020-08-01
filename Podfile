# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

target 'myContacts' do
  # Comment the next line if you don't want to use dynamic frameworks
  # use_frameworks!
  use_modular_headers!

  # Pods for easy-delete
  pod 'RealmSwift'
  pod 'NVActivityIndicatorView'

end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.name == 'Debug'
        config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-Onone']
        config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
      end
    end
  end
end
