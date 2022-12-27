//
//  RudderMoengageIntegration.h
//  Rudder-Moengage
//
//  Created by Ruchira Moitra on 28/10/20.
//

#import <Foundation/Foundation.h>
#import <Rudder/Rudder.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface RudderMoengageIntegration : NSObject<RSIntegration, UNUserNotificationCenterDelegate>

@property (nonatomic) BOOL sendEvents;

- (instancetype)initWithConfig:(NSDictionary *)config withAnalytics:(RSClient *)client withRudderConfig:(RSConfig*) rudderConfig;

@end

NS_ASSUME_NONNULL_END

