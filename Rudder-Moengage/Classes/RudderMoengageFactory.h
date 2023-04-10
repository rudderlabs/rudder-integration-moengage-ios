//
//  RudderMoengageFactory.h
//  Rudder-Moengage
//
//  Created by Ruchira Moitra on 28/10/20.
//

#import <Foundation/Foundation.h>
#import <Rudder/Rudder.h>
#import "RudderMoengageIntegration.h"

NS_ASSUME_NONNULL_BEGIN

@interface RudderMoengageFactory : NSObject<RSIntegrationFactory>
+ (instancetype) instance;

@property RudderMoengageIntegration * __nullable integration;

@end

NS_ASSUME_NONNULL_END

