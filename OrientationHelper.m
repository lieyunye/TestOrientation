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
    _interfaceOrientationMask = UIInterfaceOrientationMaskLandscapeRight;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
}

- (void)setToPortraitMode
{
    _interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
}

- (void) startListeningDeviceOrientation
{
    motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval=1.0/10.0;
    if ([motionManager isAccelerometerAvailable]) {
        NSOperationQueue *que = [[NSOperationQueue alloc] init];
        [motionManager startAccelerometerUpdatesToQueue:que withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            [self performSelectorOnMainThread:@selector(onMainThread:)
                                   withObject:accelerometerData waitUntilDone:NO];
        }];
    }
    
}

- (void) stopListeningDeviceOrientation
{
    [motionManager stopAccelerometerUpdates];
}

- (void)onMainThread:(CMAccelerometerData *)accelerometerData{

    double x = accelerometerData.acceleration.x;
    double y = accelerometerData.acceleration.y;
    double z = accelerometerData.acceleration.z;
    
    UIDeviceOrientation _deviceOrientation;

    if (fabs(y) < 0.5 && fabs(z) < 0.6) {
        if (x < 0) {
             _deviceOrientation = UIDeviceOrientationLandscapeLeft;
        }else {
            _deviceOrientation = UIDeviceOrientationLandscapeRight;
        }
    }else if (fabs(y) > 0.8 && fabs(z) < 0.6) {
        _deviceOrientation = UIDeviceOrientationPortrait;
    }
    
    switch (_deviceOrientation) {
        case UIDeviceOrientationFaceDown:
            NSLog(@"UIDeviceOrientationFaceDown");
            break;
        case UIDeviceOrientationFaceUp:
            NSLog(@"UIDeviceOrientationFaceUp");
            break;
        case UIDeviceOrientationLandscapeLeft:
            _interfaceOrientationMask = UIInterfaceOrientationMaskLandscapeRight;
            break;
        case UIDeviceOrientationLandscapeRight:
            NSLog(@"UIDeviceOrientationLandscapeRight");

            break;
        case UIDeviceOrientationPortrait:
            _interfaceOrientationMask = UIInterfaceOrientationMaskPortrait;
            break;
        case UIDeviceOrientationUnknown:
            NSLog(@"UIDeviceOrientationUnknown");

            break;
        case UIDeviceOrientationPortraitUpsideDown:
            NSLog(@"UIDeviceOrientationPortraitUpsideDown");

            break;
        default:
            break;
    }
}

@end
