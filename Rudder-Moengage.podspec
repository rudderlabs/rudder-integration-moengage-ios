Pod::Spec.new do |s|
    s.name             = 'Rudder-Moengage'
    s.version          = '1.0.0'
    s.summary          = 'Privacy and Security focused Segment-alternative. Firebase Native SDK integration support.'

    s.description      = <<-DESC
    Rudder is a platform for collecting, storing and routing customer event data to dozens of tools. Rudder is open-source, can run in your cloud environment (AWS, GCP, Azure or even your data-centre) and provides a powerful transformation framework to process your event data on the fly.
    DESC

    s.homepage         = 'https://github.com/rudderlabs/rudder-integration-moengage-ios'
    s.license          = { :type => 'Apache', :file => 'LICENSE' }
    s.author           = { 'RudderStack' => 'ruchira@rudderlabs.com' }
    s.source           = { :git => 'https://github.com/rudderlabs/rudder-integration-moengage-ios.git', :tag => 'v1.0.0' }

    s.ios.deployment_target = '9.0'

    ## Ref: https://github.com/CocoaPods/CocoaPods/issues/10065
    s.pod_target_xcconfig = {
      'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
    }
    s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

    s.source_files = 'Rudder-Moengage/Classes/**/*'

    s.dependency 'Rudder'
    s.dependency 'MoEngage-iOS-SDK', '~> 6.1.0'
end
