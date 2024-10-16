# Uncomment the next line to define a global platform for your project
# platform :ios, '11.0'

target 'ZeepLive' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ZeepLive

  target 'ZeepLiveTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ZeepLiveUITests' do
    # Pods for testing
  end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
               end
          end
   end
end
pod 'GoogleSignIn'
pod 'Alamofire'
pod 'SwiftyJSON'
pod 'Kingfisher'
pod 'DropDown'
pod 'SkyFloatingLabelTextField'
#pod 'Firebase'
#pod 'FirebaseCore'
#pod 'FirebaseAuth'
#pod 'Firebase/MLVision', '6.25.0'
#pod 'Firebase/MLVisionTextModel', '6.25.0'
#pod 'Firebase/MLVisionFaceModel', '6.25.0'
pod 'FittedSheets'
pod 'SVGAPlayer'
pod 'FirebaseDatabase'
pod 'BDAlphaPlayer'
pod 'TXIMSDK_Plus_iOS'
pod 'MessageKit'
pod 'RealmSwift'
pod 'TYPagerController'
pod 'lottie-ios'
pod 'Firebase/Crashlytics'
pod 'FirebaseMessaging'
pod "ToastViewSwift"


end
