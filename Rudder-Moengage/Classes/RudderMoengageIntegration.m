//
//  RudderMoengageIntegration.m
//  Rudder-Moengage
//
//  Created by Ruchira Moitra on 28/10/20.
//

#import "RudderMoengageIntegration.h"
#import <MoEngage/MoEngage.h>

@implementation RudderMoengageIntegration


#pragma mark - Initialization

- (instancetype) initWithConfig:(NSDictionary *)config withAnalytics:(nonnull RSClient *)client  withRudderConfig:(nonnull RSConfig *)rudderConfig {
    self = [super init];
    if(self){
        NSString *apiId = [config objectForKey:@"apiId"];
        NSString *apiKey = [config objectForKey:@"apiKey"];
        NSString *region = [config objectForKey:@"region"];
        [[MoEngage sharedInstance] initializeProdWithAppID:apiId  withLaunchOptions:nil];
        if([region isEqualToString:@"EU"]){
            [MoEngage redirectDataToRegion:MOE_REGION_EU];
        }
        [RSLogger logDebug:@"Initializing Moengage SDK"];
    }
    return self;
}
- (void) dump:(RSMessage *)message {
    @try {
        if (message != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self processRudderEvent:message];
            });
        }
    } @catch (NSException *ex) {
        [RSLogger logError:[[NSString alloc] initWithFormat:@"%@", ex]];
    }
}

- (void) processRudderEvent: (nonnull RSMessage *) message {
    NSString *type = message.type;
    NSString *event = message.event;
    
    if ([type isEqualToString:@"identify"]) {
        NSDictionary *properties = message.context.traits;
        properties = [self filterProperties:properties];
       
    }
    else if([type isEqualToString:@"track"]){
        if([event isEqualToString:@"Application Installed"]){
            [[MoEngage sharedInstance]appStatus:INSTALL];
        }else if([event isEqualToString:@"Application Updated"]){
            [[MoEngage sharedInstance]appStatus:UPDATE];
        }
        // track event example
            NSDictionary *properties = message.properties;
            NSMutableDictionary *propertiesDictionary = [self filterProperties:properties];

        MOProperties* eventProperties = [[MOProperties alloc] initWithAttributes:propertiesDictionary];


        [[MoEngage sharedInstance] trackEvent:event withProperties:eventProperties];
    }
    else {
        [RSLogger logDebug:@"Moengage Integration: Message Type not supported"];
    }
}
- (NSMutableDictionary*) filterProperties: (NSDictionary*) properties {
    NSMutableDictionary *filteredProperties = nil;
    if (properties != nil) {
        filteredProperties = [[NSMutableDictionary alloc] init];
        for (NSString *key in properties.allKeys) {
            id val = properties[key];
            if ([val isKindOfClass:[NSString class]] || [val isKindOfClass:[NSNumber class]]) {
                filteredProperties[key] = val;
            }
        }
    }
    return filteredProperties;
}

- (void)reset {

}



@end

