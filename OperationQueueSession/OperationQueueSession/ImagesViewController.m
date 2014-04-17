//
//  ImagesViewController.m
//  OperationQueueSession
//
//  Created by HDBaggy on 16/04/14.
//  Copyright (c) 2014 Space O Technology. All rights reserved.
//

#import "ImagesViewController.h"
#import "ImageCell.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"

#define kUrl @"1"

@interface ImagesViewController ()

@end

@implementation ImagesViewController

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
    [self initializeOnce];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initializeOnce
{
    [_imgCollection registerNib:[UINib nibWithNibName:@"ImageCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}


#pragma mark - Tableview Datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *objImgCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
  //  objImgCell.imgData.image = [UIImage imageNamed:@"jobs.png"];
    
    [objImgCell.imgData setImageWithURL:[NSURL URLWithString:kUrl] placeholderImage:nil];
    
    return objImgCell;
}

@end
