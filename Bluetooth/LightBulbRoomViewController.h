//
//  LightBulbRoomViewController.h
//  nextHome
//
//  Created by john on 8/4/14.
//  Copyright (c) 2014 nextHome Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"

@interface LightBulbRoomViewController : UIViewController
@property (strong,nonatomic) NSArray *devices;

- (id) initWithDevices:(NSArray *)devices;

@end
