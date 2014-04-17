//
//  ScreenshotViewController.m
//  OperationQueueSession
//
//  Created by macmini08 on 16/04/14.
//  Copyright (c) 2014 Space O Technology. All rights reserved.
//

#import "ScreenshotViewController.h"

@interface ScreenshotViewController ()

@end

@implementation ScreenshotViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _imgvScreenShot.image = _imgScreenshot;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCloseTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
