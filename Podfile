# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'GithubDiscovery' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for GithubDiscovery
  pod 'RxSwift',    '~> 3.0'
  pod 'RxCocoa',    '~> 3.0'
  pod 'Moya', '8.0.0-beta.2'
  pod 'SnapKit', '~> 3.0.2'
  pod 'ObjectMapper', '~> 2.2'
  pod 'SwiftyJSON'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'  ## or '3.0'
        end
    end
 end
  target 'GithubDiscoveryTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'GithubDiscoveryUITests' do
    inherit! :search_paths
    # Pods for testing
    
  end

end
