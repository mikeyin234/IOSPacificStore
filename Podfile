# Uncomment the next line to define a global platform for your project
# platform :ios, '13.0'
#https://firebase.google.com/docs/ios/setup

target 'PacificStore' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  # Pods for pacific store
  #pod 'Firebase/Core', '~> 6.7.0'
  pod 'Firebase/Messaging'  
  #pod 'Firebase/Auth'
  pod 'Firebase/Analytics'

  pod 'GoogleMaps'
  pod 'GooglePlaces'
 #pod "YoutubePlayer-in-WKWebView", "~> 0.3.11"
  pod "youtube-ios-player-helper"
  pod 'Mute'
  pod 'MercariQRScanner'
end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
 end

