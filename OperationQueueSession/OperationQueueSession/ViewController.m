//
//  ViewController.m
//  OperationQueueSession
//
//  Created by macmini08 on 16/04/14.
//  Copyright (c) 2014 Space O Technology. All rights reserved.
//

#import "ViewController.h"
#import "Throbber.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    objSessionApi = [SessionApi sharedSession];
    [self initializeOnce];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initializeOnce
{

}

- (IBAction)btnCaptureTapped:(id)sender
{
    [[Throbber defaultThrobber] showWithTitle:@"Loading..."];
    UIImage *imgScrenshot = [objSessionApi takeScreenShotOfView:_screenView];
    [self showScreenShot:imgScrenshot];
}

- (IBAction)btnAsyncCaptureTapped:(id)sender
{
   __block UIImage *imgScrenshot;
    
    NSOperationQueue *objMainQueue = [NSOperationQueue mainQueue];
    
    [objMainQueue addOperationWithBlock:^{
       
        [[Throbber defaultThrobber] showWithTitle:@"Loading..."];
        
    }];
    
    [objMainQueue addOperationWithBlock:^{
       
        imgScrenshot = [objSessionApi takeScreenShotOfView:_screenView];

    }];
    
    [objMainQueue addOperationWithBlock:^{
       
        [self showScreenShot:imgScrenshot];
        
    }];
    
    [objMainQueue addOperationWithBlock:^{
       
        [[Throbber defaultThrobber] dismiss];
        
    }];
}

- (IBAction)btnImageeListTapped:(id)sender
{
    _objImagesViewController = [[ImagesViewController alloc] initWithNibName:@"ImagesViewController" bundle:nil];
    [self presentViewController:_objImagesViewController
                       animated:YES completion:nil];
}

-(void)showScreenShot:(UIImage*)imgScreenshot
{
    _objScreenshotViewController = [[ScreenshotViewController alloc] initWithNibName:@"ScreenshotViewController" bundle:nil];
    _objScreenshotViewController.imgScreenshot = imgScreenshot;
    [self presentViewController:_objScreenshotViewController animated:YES completion:nil];
    [[Throbber defaultThrobber] dismiss];
}




@end
