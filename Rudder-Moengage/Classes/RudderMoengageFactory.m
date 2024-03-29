//
//  RudderMoengageFactory.m
//  Rudder-Moengage
//
//  Created by Ruchira Moitra on 28/10/20.
//

#import "RudderMoengageFactory.h"
#import "RudderMoengageIntegration.h"
@implementation RudderMoengageFactory

static RudderMoengageFactory *sharedInstance;

+ (instancetype)instance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (nonnull NSString *)key {
    return @"MoEngage";
}


- (id<RSIntegration>)initiate:(NSDictionary *)config client:(RSClient *)client rudderConfig:(nonnull RSConfig *)rudderConfig {
    [RSLogger logDebug:@"Creating RudderIntegrationFactory: MoEngage"];
    self.integration = [[RudderMoengageIntegration alloc] initWithConfig:config withAnalytics:client withRudderConfig:rudderConfig];
    return self.integration;
}

@end
