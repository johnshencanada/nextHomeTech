//
//  MyNavigationController.m
//  nextHome
//
//  Created by john on 7/2/14.
//  Copyright (c) 2014 nextHome Technology. All rights reserved.
//

#import "MyNavigationController.h"
@interface MyNavigationController ()
@property CGRect screenRect;

@end

@implementation MyNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.screenRect = [[UIScreen mainScreen] bounds];

    /* blur effect background */
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.screenRect.size.width, self.screenRect.size.height)];
    imageView.image = [UIImage imageNamed:@"house"];
    [self.view addSubview:imageView];
    self.blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurView =  [[UIVisualEffectView alloc]initWithEffect:self.blurEffect];
    self.blurView.frame = imageView.bounds;
    [imageView addSubview:self.blurView];
    [self.view sendSubviewToBack:imageView];

    self.navigationBar.barTintColor = [UIColor blackColor];
    self.toolbar.barTintColor =[UIColor blackColor];
    self.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.toolbar.barStyle = UIBarStyleBlackOpaque;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"refresh" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationBar.hidden = true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
