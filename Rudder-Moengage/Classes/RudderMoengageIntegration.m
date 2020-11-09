//
//  RudderMoengageIntegration.m
//  Rudder-Moengage
//
//  Created by Ruchira Moitra on 28/10/20.
//

#import "RudderMoengageIntegration.h"
#import <MoEngage/MoEngage.h>
#import <Rudder/Rudder.h>

@implementation RudderMoengageIntegration

#pragma mark - Initialization

- (instancetype) initWithConfig:(NSDictionary *)config withAnalytics:(nonnull RSClient *)client  withRudderConfig:(nonnull RSConfig *)rudderConfig {
  self = [super init];
  if (self) {
    [RSLogger logDebug:@"Initializing Moengage SDK"];
    dispatch_async(dispatch_get_main_queue(), ^{
      //take values from config
      NSString *apiId = [config objectForKey:@"apiId"];
      NSString *region = [config objectForKey:@"region"];

      //check if debug mode on or off
#ifdef DEBUG
      [[MoEngage sharedInstance] initializeDevWithAppID:apiId withLaunchOptions:nil];
#else
      [[MoEngage sharedInstance] initializeProdWithAppID:apiId withLaunchOptions:nil];
#endif

      //redirect data according to region
      if ([region isEqualToString:@"EU"]) {
        [MoEngage redirectDataToRegion:MOE_REGION_EU];
      }

      //set anonymous id as attritbute
      NSString* anonymousId = [[RSClient sharedInstance] getAnonymousId];
      if (anonymousId != nil) {
        [[MoEngage sharedInstance] setUserAttribute:anonymousId forKey:@"anonymousId"];
      }
    });

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
    NSDictionary *properties = message.context.traits;
    NSMutableDictionary *traits = [self filterProperties:properties];
    NSString* anonymousId = message.anonymousId;
    if (anonymousId != nil) {
      [[MoEngage sharedInstance] setUserAttribute:anonymousId forKey:@"anonymousId"];
    }
    NSString *userId = message.userId;
    if (userId != nil) {
      [[MoEngage sharedInstance] setUserAttribute:userId forKey:USER_ATTRIBUTE_UNIQUE_ID];
    }
    if (traits != nil) {
      //set all predefined fields
      if ([traits objectForKey:@"id"]) {
        [[MoEngage sharedInstance] setUserUniqueID:[traits objectForKey:@"id"]];
        [traits removeObjectForKey:@"id"];
      }

      if ([traits objectForKey:@"email"]) {
        [[MoEngage sharedInstance] setUserEmailID:[traits objectForKey:@"email"]];
        [traits removeObjectForKey:@"email"];
      }

      if ([traits objectForKey:@"name"]) {
        [[MoEngage sharedInstance] setUserName:[traits objectForKey:@"name"]];
        [traits removeObjectForKey:@"name"];
      }

      if ([traits objectForKey:@"phone"]) {
        [[MoEngage sharedInstance] setUserMobileNo:[traits objectForKey:@"phone"]];
        [traits removeObjectForKey:@"phone"];
      }

      if ([traits objectForKey:@"firstName"]) {
        [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"firstName"] forKey:USER_ATTRIBUTE_USER_FIRST_NAME];
        [traits removeObjectForKey:@"firstName"];
      }

      if ([traits objectForKey:@"lastName"]) {
        [[MoEngage sharedInstance] setUserLastName:[traits objectForKey:@"lastName"]];
        [traits removeObjectForKey:@"lastName"];
      }
        
      if ([traits objectForKey:@"firstname"]) {
        [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"firstname"] forKey:USER_ATTRIBUTE_USER_FIRST_NAME];
        [traits removeObjectForKey:@"firstname"];
      }

      if ([traits objectForKey:@"lastname"]) {
        [[MoEngage sharedInstance] setUserLastName:[traits objectForKey:@"lastname"]];
        [traits removeObjectForKey:@"lastname"];
      }
        
      if ([traits objectForKey:@"gender"]) {
        [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"gender"] forKey:USER_ATTRIBUTE_USER_GENDER];
        [traits removeObjectForKey:@"gender"];
      }

      if ([traits objectForKey:@"birthday"]) {
        id birthdayVal = [traits objectForKey:@"birthday"];
        if (birthdayVal != nil) {
          [self identifyDateUserAttribute:birthdayVal withKey:USER_ATTRIBUTE_USER_BDAY];
        }
        [traits removeObjectForKey:@"birthday"];
      }

      if ([traits objectForKey:@"address"]) {
        [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"address"] forKey:@"address"];
        [traits removeObjectForKey:@"address"];
      }

      if ([traits objectForKey:@"age"]) {
        [[MoEngage sharedInstance] setUserAttribute:[traits objectForKey:@"age"] forKey:@"age"];
        [traits removeObjectForKey:@"age"];
      }

      for (NSString *key in [traits allKeys]) {
        id value = [traits objectForKey:key];
        if (value != nil) {
          [self identifyDateUserAttribute:value withKey:key];
        }
      }
    }
  } else if ([type isEqualToString:@"track"]) {
    NSString *event = message.event;
    if ([event isEqualToString:@"Application Installed"]) {
      [[MoEngage sharedInstance]appStatus:INSTALL];
    } else if ([event isEqualToString:@"Application Updated"]) {
      [[MoEngage sharedInstance]appStatus:UPDATE];
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
            [dateAttributeDict setValue:convertedDate forKey:key];
            [propertiesDictionary removeObjectForKey:key];
          }
        }
      }
      MOProperties* eventProperties = [[MOProperties alloc] initWithAttributes:propertiesDictionary];

      for (NSString* key in dateAttributeDict.allKeys) {
        NSDate *dateVal = [dateAttributeDict valueForKey:key];
        [eventProperties addDateAttribute:dateVal withName:key];
      }
      [[MoEngage sharedInstance] trackEvent:event withProperties:eventProperties];
    } else {
      [[MoEngage sharedInstance] trackEvent:event withProperties:nil];
    }
  } else if ([type isEqualToString:@"alias"]) {
    //to merge two profiles
    id newID = message.userId;
    if (newID != nil) {
      if ([[MoEngage sharedInstance] respondsToSelector:@selector(setAlias:)]) {
        [[MoEngage sharedInstance] setAlias:newID];
      }
    }
  } else {
    [RSLogger logDebug:@"Moengage Integration: Message Type not supported"];
  }
}

- (void)reset {
  [[MoEngage sharedInstance] resetUser];
}

- (void)flush {
  [[MoEngage sharedInstance] syncNow];
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
  [[MoEngage sharedInstance] setPushToken:deviceToken];
}

- (void)failedToRegisterForRemoteNotificationsWithError:(NSError *)error {
  [[MoEngage sharedInstance] didFailToRegisterForPush];
}

- (void)receivedRemoteNotification:(NSDictionary *)userInfo {
  [[MoEngage sharedInstance] didReceieveNotificationinApplication:[UIApplication sharedApplication] withInfo:userInfo];
}

- (void)handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo {
  [[MoEngage sharedInstance] handleActionWithIdentifier:identifier forRemoteNotification:userInfo];
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
  [[MoEngage sharedInstance] userNotificationCenter:center didReceiveNotificationResponse:response];
  completionHandler();
}

#pragma mark - Utils
-(void)identifyDateUserAttribute:(id)value withKey:(NSString*)attr_name {
  if ([value isKindOfClass:[NSString class]]) {
    NSDate* convertedDate = [self dateFromISOdateStr:value];
    if (convertedDate != nil) {
      [[MoEngage sharedInstance] setUserAttributeTimestamp:[convertedDate timeIntervalSince1970] forKey:attr_name];
      return;
    }
  }
  [[MoEngage sharedInstance] setUserAttribute:value forKey:attr_name];
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

