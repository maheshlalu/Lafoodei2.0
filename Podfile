# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Lefoodie' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Lefoodie
pod 'AFNetworking', '~> 3.1'
pod 'MagicalRecord/Shorthand'
pod 'SKPhotoBrowser', :git => 'https://github.com/suzuki-0000/SKPhotoBrowser.git', :branch => 'swift3'
pod 'Alamofire', '~> 4.0'
pod 'Firebase/Messaging'
pod 'MagicalRecord/Shorthand'
pod "KRProgressHUD"
pod 'MBProgressHUD', '~> 1.0'
pod 'Google/SignIn'
pod 'Firebase/Core'
pod 'SwifterSwift'
pod 'SDWebImage', '~> 3.8'
pod 'GSKStretchyHeaderView'
pod 'Masonry'
pod 'SwiftyJSON'
pod "MXParallaxHeader"
pod 'RealmSwift'
pod 'RSKKeyboardAnimationObserver', '1.0.0'
pod 'RSKPlaceholderTextView', '2.0.0'
pod 'Firebase/Database'
pod 'Firebase/Auth'
pod 'FlickrKit'
pod 'TMTumblrSDK'
pod 'Flurry-iOS-SDK/FlurrySDK'
pod 'Flurry-iOS-SDK/FlurryAds'
pod 'Fabric'
pod 'TwitterKit'
pod 'OAuthSwift', '~> 1.1.0'

  target 'LefoodieTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'LefoodieUITests' do
    inherit! :search_paths
    # Pods for testing
  end

  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '3.0'
          end
      end
      
  end
  
  
end
