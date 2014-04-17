//
//  ImagesViewController.h
//  OperationQueueSession
//
//  Created by HDBaggy on 16/04/14.
//  Copyright (c) 2014 Space O Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagesViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *imgCollection;
@end
