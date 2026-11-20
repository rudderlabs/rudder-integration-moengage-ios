//
//  RudderMoengageFactory.h
//  Rudder-Moengage
//
//  Created by Ruchira Moitra on 28/10/20.
//

#import <Foundation/Foundation.h>
#if defined(__has_include) && __has_include(<Rudder/Rudder.h>)
#import <Rudder/Rudder.h>
#else
#import "Rudder.h"
#endif
#import "RudderMoengageIntegration.h"

NS_ASSUME_NONNULL_BEGIN

@interface RudderMoengageFactory : NSObject<RSIntegrationFactory>
+ (instancetype) instance;

@property RudderMoengageIntegration * __nullable integration;

@end

NS_ASSUME_NONNULL_END

