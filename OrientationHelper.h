//
//  OrientationHelper.h
//  TestOrientation
//
//  Created by lieyunye on 4/21/16.
//  Copyright © 2016 lieyunye. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface OrientationHelper : NSObject
+ (instancetype)sharedClient;
- (UIInterfaceOrientationMask)currentInterfaceOrientation;
- (void)setToLandScapeMode;
- (void)setToPortraitMode;
- (void) startListeningDeviceOrientation;
- (void) stopListeningDeviceOrientation;


@end
