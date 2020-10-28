//
//  RudderMoengageFactory.h
//  Rudder-Moengage
//
//  Created by Ruchira Moitra on 28/10/20.
//

#import <Foundation/Foundation.h>
#import <Rudder/Rudder.h>

NS_ASSUME_NONNULL_BEGIN

@interface RudderMoengageFactory : NSObject<RSIntegrationFactory>
+ (instancetype) instance;
@end

NS_ASSUME_NONNULL_END

