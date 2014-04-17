//
//  SessionApi.m
//  OperationQueueSession
//
//  Created by macmini08 on 16/04/14.
//  Copyright (c) 2014 Space O Technology. All rights reserved.
//

#import "SessionApi.h"

@implementation SessionApi

+(SessionApi*)sharedSession
{
    __strong static id _sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[SessionApi alloc] init];
    });
    return _sharedObject;
}

-(UIImage*)takeScreenShotOfView:(UIView*)pobjView
{
    CGRect desiredFrame = pobjView.frame;
    UIGraphicsBeginImageContextWithOptions(desiredFrame.size, YES, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -desiredFrame.origin.x, -desiredFrame.origin.y);
    [pobjView.layer renderInContext:context];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

@end
