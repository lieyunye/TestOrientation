//
//  OrientationHelper.m
//  TestOrientation
//
//  Created by lieyunye on 4/21/16.
//  Copyright © 2016 lieyunye. All rights reserved.
//

#import "OrientationHelper.h"
#import <CoreMotion/CoreMotion.h>

@implementation OrientationHelper
{
    UIInterfaceOrientationMask _interfaceOrientationMask;
    CMMotionManager *motionManager;
    BOOL _stopCheckOrientation;
    
}

+ (instancetype)sharedClient
{
    static OrientationHelper *_sharedClient = nil;
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken, ^{
        _sharedClient = [[OrientationHelper alloc] init];
    });
    return _sharedClient;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self startListeningDeviceOrientation];
        
    }
    return self;
}

- (UIInterfaceOrientationMask)currentInterfaceOrientation
{
    return _interfaceOrientationMask;
}

- (void)setToLandScapeMode
{
    if (!_stopCheckOrientation) {
        if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
        }
    }
    _interfaceOrientationMask = UIInterfaceOrientationMaskLandscapeRight;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
}

- (void)setToPortraitMode
{
    if (!_stopCheckOrientation) {
        //1、如果是device已经是UIDeviceOrientationPortrait 需设置先UIDeviceOrientationLandscapeLeft后再设置UIDeviceOrientationPortrait来触发layoutsubviews 2、_stopCheckOrientation来防止设置了UIDeviceOrientationLandscapeLeft，之后shouldAutorotate返回NO，此时再设置UIDeviceOrientationPortrait无效的问题
        if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait) {
            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
        }
    }
    _interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
}

- (void) startListeningDeviceOrientation
{
    _stopCheckOrientation = NO;
//    if (IOS_VERSION < 8) {//iOS8以下不支持自动旋转
//        return;
//    }
    motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval=1.0/10.0;
    if ([motionManager isAccelerometerAvailable]) {
        [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            if (_stopCheckOrientation) {
                _interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
                return;
            }
            if (accelerometerData.acceleration.x <= -0.75) {
                _interfaceOrientationMask = UIInterfaceOrientationMaskLandscapeRight;
//                DDLogDebug(@"UIInterfaceOrientationMaskLandscapeRight");
            }else if (accelerometerData.acceleration.y <= -0.75) {
                _interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
//                DDLogDebug(@"UIDeviceOrientationPortrait");
            }else {
//                DDLogDebug(@"UIDeviceOrientationElse");
                return;
            }
        }];
    }
}

- (void) stopListeningDeviceOrientation
{
    _stopCheckOrientation = YES;
    [motionManager stopAccelerometerUpdates];
}

@end
