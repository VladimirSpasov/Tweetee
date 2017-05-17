# Uncomment this line to define a global platform for your project
platform :ios, '9.0'

target 'Tweetee' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  pod 'OAuthSwift'
  pod 'OAuthSwiftAlamofire'
  pod 'SwiftyJSON'
  pod 'Locksmith'

  pod 'RealmSwift'
  pod 'AlamofireObjectMapper'
  pod 'AlamofireImage'

  pod 'Atributika'


  use_frameworks!

  # Pods for Tweetee

  target 'TweeteeTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'TweeteeUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
              config.build_settings['ENABLE_TESTABILITY'] = 'YES'
              config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
