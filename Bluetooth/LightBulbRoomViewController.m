//
//  LightBulbRoomViewController.m
//  nextHome
//
//  Created by john on 8/4/14.
//  Copyright (c) 2014 nextHome Technology. All rights reserved.
//

#import "LightBulbRoomViewController.h"
#import "MyNavigationController.h"

@interface LightBulbRoomViewController ()

@end

@implementation LightBulbRoomViewController

-(id)initWithDevices:(NSArray *)devices
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor clearColor];
        UIImage *home = [UIImage imageNamed:@"home"];
        UITabBarItem *homeTab = [[UITabBarItem alloc] initWithTitle:@"Home" image:home tag:0];
        self.tabBarItem = homeTab;
    }
    return self;
}

@end
