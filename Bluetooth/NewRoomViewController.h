//
//  NewRoomViewController.h
//  Bluetooth
//
//  Created by john on 9/11/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLSimpleCamera.h"
#import "NewRoomChildViewController.h"

@interface NewRoomViewController : UIViewController <UIPageViewControllerDataSource>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@end
