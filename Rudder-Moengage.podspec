require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
    s.name             = 'Rudder-Moengage'
    s.version          = package['version']
    s.summary          = 'Privacy and Security focused Segment-alternative. Firebase Native SDK integration support.'

    s.description      = <<-DESC
    Rudder is a platform for collecting, storing and routing customer event data to dozens of tools. Rudder is open-source, can run in your cloud environment (AWS, GCP, Azure or even your data-centre) and provides a powerful transformation framework to process your event data on the fly.
    DESC

    s.homepage         = 'https://github.com/rudderlabs/rudder-integration-moengage-ios'
    s.license          = { :type => 'Apache', :file => 'LICENSE' }
    s.author           = { 'RudderStack' => 'ruchira@rudderlabs.com' }
    s.source           = { :git => 'https://github.com/rudderlabs/rudder-integration-moengage-ios.git', :tag => "v#{s.version}" }

    s.ios.deployment_target = '10.0'

    s.source_files = 'Rudder-Moengage/Classes/**/*'

    s.dependency 'Rudder', '~> 1.0'
    s.dependency 'MoEngage-iOS-SDK', '9.1.0'
end
