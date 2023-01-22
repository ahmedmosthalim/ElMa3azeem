# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

target 'ElMa3azeem' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ElMa3azeem

	pod 'Socket.IO-Client-Swift' ,'~> 15.2.0'
#  pod 'Localize-Swift'
 	 pod 'SwiftyJSON'
 	 pod 'GoogleMaps'
  	pod 'GooglePlaces'
  	pod 'Cosmos'
  	pod 'IQKeyboardManagerSwift'
  	pod 'Kingfisher', '~> 7.0'
 	pod 'Alamofire'
  	pod 'Firebase/Core'
  	pod 'Firebase/Messaging'
  	pod 'Firebase/Crashlytics'
  	pod 'SwiftMessages'
  	pod 'BottomPopup'
  	pod 'ImageSlideshow'
  	pod 'ImageSlideshow/Kingfisher'
  	pod 'NVActivityIndicatorView', :git => 'https://github.com/AbdallaTarek/NVActivityIndicatorView.git'
  	pod "PageControls/SnakePageControl"
  	pod 'OTPFieldView', :git => 'https://github.com/AbdallaTarek/OTPFieldView.git'
  	pod 'TransitionButton'
  	pod 'GoogleSignIn'
  	pod 'FBSDKCoreKit'
  	pod 'FBSDKLoginKit'
  	pod 'lottie-ios'
  
  post_install do |installer_representation|
        installer_representation.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['ONLY_ACTIVE_ARCH'] = 'No'
                config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
            end
        end
    end
  
end

