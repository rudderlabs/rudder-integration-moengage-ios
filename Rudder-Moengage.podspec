#
# Be sure to run `pod lib lint Rudder-Moengage.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

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
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.ios.deployment_target = '9.0'
    
    s.source_files = 'Rudder-Moengage/Classes/**/*'
    
    s.dependency 'Rudder'
    s.dependency 'MoEngage-iOS-SDK', '~> 6.1.0'
end
