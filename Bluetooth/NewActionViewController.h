//
//  NewActionViewController.h
//  nextHome
//
//  Created by john on 12/20/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"

@interface NewActionViewController : UIViewController <UIPageViewControllerDataSource>
@property (strong,nonatomic) NSArray *devices;
@property (strong, nonatomic) UIPageViewController *pageViewController;
- (id) initWithDevices:(NSArray *)devices;

@end
