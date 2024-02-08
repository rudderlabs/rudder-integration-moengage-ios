require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

moengage_sdk_version = '~> 9.5'
rudder_sdk_version = '~> 1.12'

Pod::Spec.new do |s|
    s.name             = 'Rudder-Moengage'
    s.version          = package['version']
    s.summary          = 'Privacy and Security focused Segment-alternative. Firebase Native SDK integration support.'

    s.description      = <<-DESC
    Rudder is a platform for collecting, storing and routing customer event data to dozens of tools. Rudder is open-source, can run in your cloud environment (AWS, GCP, Azure or even your data-centre) and provides a powerful transformation framework to process your event data on the fly.
    DESC

    s.homepage         = 'https://github.com/rudderlabs/rudder-integration-moengage-ios'
    s.license          = { :type => "ELv2", :file => "LICENSE.md" }
    s.author           = { 'RudderStack' => 'ruchira@rudderlabs.com' }
    s.source           = { :git => 'https://github.com/rudderlabs/rudder-integration-moengage-ios.git', :tag => "v#{s.version}" }

    s.ios.deployment_target = '10.0'
    s.source_files = 'Rudder-Moengage/Classes/**/*'

    if defined?($MoengageSDKVersion)
        Pod::UI.puts "#{s.name}: Using user specified Moengage SDK version '#{$MoengageSDKVersion}'"
        moengage_sdk_version = $MoengageSDKVersion
    else
        Pod::UI.puts "#{s.name}: Using default Moengage SDK version '#{moengage_sdk_version}'"
    end
    
    if defined?($RudderSDKVersion)
        Pod::UI.puts "#{s.name}: Using user specified Rudder SDK version '#{$RudderSDKVersion}'"
        rudder_sdk_version = $RudderSDKVersion
    else
        Pod::UI.puts "#{s.name}: Using default Rudder SDK version '#{rudder_sdk_version}'"
    end
    
    s.dependency 'Rudder', rudder_sdk_version
    s.dependency 'MoEngage-iOS-SDK', moengage_sdk_version
end
