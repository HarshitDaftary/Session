//
//  ScreenshotViewController.h
//  OperationQueueSession
//
//  Created by macmini08 on 16/04/14.
//  Copyright (c) 2014 Space O Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenshotViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imgvScreenShot;

@property (strong, nonatomic) UIImage *imgScreenshot;

- (IBAction)btnCloseTapped:(id)sender;

@end
