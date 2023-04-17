# What is RudderStack?

[RudderStack](https://rudderstack.com/) is a **customer data pipeline** tool for collecting, routing and processing data from your websites, apps, cloud tools, and data warehouse.

More information on RudderStack can be found [here](https://github.com/rudderlabs/rudder-server).

## Integrating MoEngage with RudderStack's iOS SDK

1. Add [Moengage](https://app.moengage.com/) as a destination in the [Dashboard](https://app.rudderstack.com/) and define all the fields.

2. Rudder-Moenagage is available through [CocoaPods](https://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
pod 'Rudder-Moengage', '~> 2.1.0'
```

3. After adding the dependency followed by ```pod install```, you can add the imports to your ```AppDelegate.m``` file, as shown:

```
#import "RudderMoengageFactory.h"
```

## Initialize ```RudderClient```

Put this code in your ```AppDelegate.m``` file under the method ```didFinishLaunchingWithOptions```
```
RSConfigBuilder *builder = [[RSConfigBuilder alloc] init];
[builder withDataPlaneUrl:<YOUR_DATA_PLANE_URL>];
[builder withFactory:[RudderMoengageFactory instance]];
[RSClient getInstance:<YOUR_WRITE_KEY> config:[builder build]];
```

## Send Events

Follow the steps from the [RudderStack iOS SDK](https://github.com/rudderlabs/rudder-sdk-ios).

## Contact Us

If you come across any issues while configuring or using this integration, feel free to start a conversation on our [Slack](https://resources.rudderstack.com/join-rudderstack-slack) channel. We will be happy to help you.
