# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

target 'myContacts' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_modular_headers!

  # Pods for myContacts
  pod 'RealmSwift'
  pod 'Eureka'

end


post_install do |installer|
     installer.pods_project.targets.each do |target|
           target.build_configurations.each do |config|
                 config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
           end
     end
 end
