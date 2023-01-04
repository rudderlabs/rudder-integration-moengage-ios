//
//  RudderMoengageIntegration.m
//  Rudder-Moengage
//
//  Created by Ruchira Moitra on 28/10/20.
//

#import "RudderMoengageIntegration.h"
@import MoEngageSDK;
#import <Rudder/Rudder.h>

@implementation RudderMoengageIntegration

#pragma mark - Initialization
NSArray *identifyTraits;

- (instancetype) initWithConfig:(NSDictionary *)config withAnalytics:(nonnull RSClient *)client  withRudderConfig:(nonnull RSConfig *)rudderConfig {
  self = [super init];
  if (self) {
    [RSLogger logDebug:@"Initializing Moengage SDK"];
    dispatch_async(dispatch_get_main_queue(), ^{
      //take values from config
      NSString *apiId = [config objectForKey:@"apiId"];
      NSString *region = [config objectForKey:@"region"];

      MoEngageSDKConfig* sdkConfig = [[MoEngageSDKConfig alloc] initWithAppID:apiId];
      
      // enable debugging
      if (rudderConfig.logLevel != RSLogLevelNone) {
        sdkConfig.enableLogs = true;
      }

      //check if debug mode on or off
#ifdef DEBUG
      [[MoEngage sharedInstance] initializeDefaultTestInstance:sdkConfig sdkState:MoEngageSDKStateEnabled];
#else
      [[MoEngage sharedInstance] initializeLiveInstance:sdkConfig];
#endif

      //redirect data according to region, refer MoEngage doc: https://help.moengage.com/hc/en-us/articles/360057030512-Data-Centers-in-MoEngage#01G5DQVXGT2KZMXTJPF77QPJ25
      if ([region isEqualToString:@"EU"]) {
        sdkConfig.moeDataCenter = MoEngageDataCenterData_center_02;
      } else if ([region isEqualToString:@"US"]) {
        sdkConfig.moeDataCenter = MoEngageDataCenterData_center_01;
      } else if ([region isEqualToString:@"IND"]){
        sdkConfig.moeDataCenter = MoEngageDataCenterData_center_03;
      }

      //set anonymous id as attritbute
      NSString* anonymousId = [[RSClient sharedInstance] getAnonymousId];
      if (anonymousId != nil) {
        [[MoEngageSDKAnalytics sharedInstance] setUserAttribute:anonymousId withAttributeName:@"anonymousId"];
      }
    });
    
    identifyTraits = [NSArray arrayWithObjects: @"id", @"email", @"name", @"phone", @"firstName", @"lastName",
                      @"firstname", @"lastname", @"gender", @"birthday", @"address", @"age", nil];

    if (@available(iOS 10.0, *)) {
      if ([UNUserNotificationCenter currentNotificationCenter].delegate == nil) {
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
      }
    }
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

  if ([type isEqualToString:@"identify"]) {
    [self reset];
    NSDictionary *properties = message.context.traits;
    NSMutableDictionary *traits = [self filterProperties:properties];
    NSString* anonymousId = message.anonymousId;
    if (anonymousId != nil) {
      [[MoEngageSDKAnalytics sharedInstance] setUserAttribute:anonymousId withAttributeName:@"anonymousId"];
    }
    NSString *userId = message.userId;
    if (traits != nil) {
      //set all predefined fields
      if (userId != nil) {
        [[MoEngageSDKAnalytics sharedInstance] setUniqueID:userId];
      }
      
      if ([traits objectForKey:@"email"]) {
        [[MoEngageSDKAnalytics sharedInstance] setEmailID:[traits objectForKey:@"email"]];
      }
      
      if ([traits objectForKey:@"name"]) {
        [[MoEngageSDKAnalytics sharedInstance] setName:[traits objectForKey:@"name"]];
      }
      
      if ([traits objectForKey:@"phone"]) {
        [[MoEngageSDKAnalytics sharedInstance] setMobileNumber:[traits objectForKey:@"phone"]];
      }
      
      if ([traits objectForKey:@"firstName"]) {
        [[MoEngageSDKAnalytics sharedInstance] setFirstName:[traits objectForKey:@"firstName"]];
      } else if ([traits objectForKey:@"firstname"]) {
        [[MoEngageSDKAnalytics sharedInstance] setFirstName:[traits objectForKey:@"firstname"]];
      }
      
      if ([traits objectForKey:@"lastName"]) {
        [[MoEngageSDKAnalytics sharedInstance] setLastName:[traits objectForKey:@"lastName"]];
      } else if ([traits objectForKey:@"lastname"]) {
        [[MoEngageSDKAnalytics sharedInstance] setLastName:[traits objectForKey:@"lastname"]];
      }
      
      NSString *gender =[traits objectForKey:@"gender"];
      if (gender) {
        if ([gender  isEqual: @"M"] || [gender  isEqualToString: @"MALE"]) {
          [[MoEngageSDKAnalytics sharedInstance] setGender:MoEngageUserGenderMale];
        }
        else if ([gender  isEqual: @"F"] || [gender  isEqualToString: @"FEMALE"]) {
          [[MoEngageSDKAnalytics sharedInstance] setGender:MoEngageUserGenderFemale];
        }
      }
      
      if ([traits objectForKey:@"birthday"]) {
        id birthdayVal = [traits objectForKey:@"birthday"];
        if (birthdayVal != nil) {
          [[MoEngageSDKAnalytics sharedInstance] setDateOfBirth:birthdayVal];
        }
      }
      
      if ([traits objectForKey:@"address"]) {
        [[MoEngageSDKAnalytics sharedInstance] setUserAttribute:[traits objectForKey:@"address"] withAttributeName:@"address"];
      }
      
      if ([traits objectForKey:@"age"]) {
        [[MoEngageSDKAnalytics sharedInstance] setUserAttribute:[traits objectForKey:@"age"] withAttributeName:@"age"];
      }
      
      for (NSString *key in [traits allKeys]) {
        if ([identifyTraits containsObject:key]) {
          continue;
        }
        id value = [traits objectForKey:key];
        if (value != nil) {
          [self identifyDateUserAttribute:value withKey:key];
        }
      }
    }
  } else if ([type isEqualToString:@"track"]) {
    NSString *event = message.event;
    if ([event isEqualToString:@"Application Installed"]) {
      [[MoEngageSDKAnalytics sharedInstance] appStatus:MoEngageAppStatusInstall forAppID:nil];
      return;
    } else if ([event isEqualToString:@"Application Updated"]) {
      [[MoEngageSDKAnalytics sharedInstance] appStatus:MoEngageAppStatusUpdate forAppID:nil];
      return;
    }

    // track event
    NSDictionary *properties = message.properties;
    if (properties != nil) {
      NSMutableDictionary *propertiesDictionary = [self filterProperties:properties];
      NSMutableDictionary *dateAttributeDict = [NSMutableDictionary dictionary];

      for (NSString* key in properties.allKeys) {
        id val = [properties valueForKey:key];
        if ([val isKindOfClass:[NSString class]]) {
          NSDate* convertedDate = [self dateFromISOdateStr:val];
          if (convertedDate != nil) {
            dateAttributeDict[key] = convertedDate;
            [propertiesDictionary removeObjectForKey:key];
          }
        }
      }
      MoEngageProperties* eventProperties = [[MoEngageProperties alloc] initWithAttributes:propertiesDictionary];
      
      for (NSString* key in dateAttributeDict.allKeys) {
        NSDate *dateVal = [dateAttributeDict valueForKey:key];
        [eventProperties addDateAttribute:dateVal withName:key];
      }
      [[MoEngageSDKAnalytics sharedInstance] trackEvent:event withProperties:eventProperties];
    } else {
      [[MoEngageSDKAnalytics sharedInstance] trackEvent:event withProperties:nil];
    }
  } else if ([type isEqualToString:@"alias"]) {
    //to merge two profiles
    id newID = message.userId;
    if (newID != nil) {
      if ([[MoEngageSDKAnalytics sharedInstance] respondsToSelector:@selector(setAlias:)]) {
        [[MoEngageSDKAnalytics sharedInstance] setAlias:newID];
      }
    }
  } else {
    [RSLogger logDebug:@"Moengage Integration: Message Type not supported"];
  }
}

- (void)reset {
  [[MoEngageSDKAnalytics sharedInstance] resetUser];
  [RSLogger logVerbose:@"Moengage RESET API is called."];
}

// For syncing the tracked events instantaneously, use the flush method
- (void)flush {
  [[MoEngageSDKAnalytics sharedInstance] flush];
  [RSLogger logVerbose:@"Moengage Flush API is called."];
}

#pragma mark- Application Life cycle methods

-(void)applicationDidFinishLaunching:(NSNotification *)notification {
  dispatch_async(dispatch_get_main_queue(), ^{
    if ([[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
      [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
  });
}

#pragma mark- Push Notification methods

-(void)registeredForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  [[MoEngageSDKMessaging sharedInstance] setPushToken:deviceToken];
}

- (void)failedToRegisterForRemoteNotificationsWithError:(NSError *)error {
  [[MoEngageSDKMessaging sharedInstance] didFailToRegisterForPush];
}

- (void)receivedRemoteNotification:(NSDictionary *)userInfo {
  [[MoEngageSDKMessaging sharedInstance] didReceieveNotificationInApplication:[UIApplication sharedApplication] withInfo:userInfo];
}

#pragma mark- User Notification Center delegate methods

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
     willPresentNotification:(UNNotification *)notification
     withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler API_AVAILABLE(ios(10.0)) {
  completionHandler((UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert ));
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
     withCompletionHandler:(nonnull void (^)(void))completionHandler API_AVAILABLE(ios(10.0)) {
  [[MoEngageSDKMessaging sharedInstance] userNotificationCenter:center didReceive:response];
  completionHandler();
}

#pragma mark - Utils
-(void)identifyDateUserAttribute:(id)value withKey:(NSString*)attr_name {
  if ([value isKindOfClass:[NSString class]]) {
    NSDate* convertedDate = [self dateFromISOdateStr:value];
    if (convertedDate != nil) {
      [[MoEngageSDKAnalytics sharedInstance] setUserAttributeEpochTime:[convertedDate timeIntervalSince1970] withAttributeName:attr_name];
      return;
    }
  }
  [[MoEngageSDKAnalytics sharedInstance] setUserAttribute:value withAttributeName:attr_name];
}

- (NSMutableDictionary*) filterProperties: (NSDictionary*) properties {
  NSMutableDictionary *filteredProperties = nil;
  if (properties != nil) {
    filteredProperties = [[NSMutableDictionary alloc] init];
    for (NSString *key in properties.allKeys) {
      id val = properties[key];
      if ([val isKindOfClass:[NSString class]] || [val isKindOfClass:[NSNumber class]] || [val isKindOfClass:[NSDate class]]) {
        filteredProperties[key] = val;
      }
    }
  }
  return filteredProperties;
}

- (NSDate*)dateFromISOdateStr:(NSString*)isoDateStr {
  if (isoDateStr != nil) {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      dateFormatter = [[NSDateFormatter alloc] init];
      dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
      dateFormatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'";
      dateFormatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    });
    return [dateFormatter dateFromString:isoDateStr];
  }
  return nil;
}

@end

