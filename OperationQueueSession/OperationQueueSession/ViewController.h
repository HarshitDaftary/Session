//
//  ViewController.h
//  OperationQueueSession
//
//  Created by macmini08 on 16/04/14.
//  Copyright (c) 2014 Space O Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionApi.h"
#import "ScreenshotViewController.h"
#import "ImagesViewController.h"


#define kUrl @"http://appassets.spaceodigicom.com/temp/jobs.jpg"

@interface ViewController : UIViewController
{
    SessionApi *objSessionApi;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgOriginal;

@property (weak, nonatomic) IBOutlet UIImageView *imgScreenshot;

@property (strong, nonatomic) ScreenshotViewController *objScreenshotViewController;

@property (strong, nonatomic) ImagesViewController *objImagesViewController;

@property (weak, nonatomic) IBOutlet UIView *screenView;
- (IBAction)btnCaptureTapped:(id)sender;
- (IBAction)btnAsyncCaptureTapped:(id)sender;
- (IBAction)btnImageeListTapped:(id)sender;

@end
