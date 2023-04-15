//
//  RudderMoengageIntegration.h
//  Rudder-Moengage
//
//  Created by Ruchira Moitra on 28/10/20.
//

#import <Foundation/Foundation.h>
#import <Rudder/Rudder.h>

NS_ASSUME_NONNULL_BEGIN

@interface RudderMoengageIntegration : NSObject<RSIntegration> {
    NSArray *identifyTraits;
}

- (instancetype)initWithConfig:(NSDictionary *)config withAnalytics:(RSClient *)client withRudderConfig:(RSConfig*) rudderConfig;

- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END

