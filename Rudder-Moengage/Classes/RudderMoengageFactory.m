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
    return @"Moengage";
}


- (id<RSIntegration>)initiate:(NSDictionary *)config client:(RSClient *)client rudderConfig:(nonnull RSConfig *)rudderConfig {
    [RSLogger logDebug:@"Creating RudderIntegrationFactory"];
    return [[RudderMoengageIntegration alloc] initWithConfig:config withAnalytics:client withRudderConfig:rudderConfig];
}

@end
