//
//  SessionApi.h
//  OperationQueueSession
//
//  Created by macmini08 on 16/04/14.
//  Copyright (c) 2014 Space O Technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionApi : NSObject

+(SessionApi*)sharedSession;
-(UIImage*)takeScreenShotOfView:(UIView*)pobjView;


@end
