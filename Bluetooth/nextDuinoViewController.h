//
//  nextDuinoViewController.h
//  nextHome
//
//  Created by john on 11/14/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"

@interface nextDuinoViewController : UIViewController

@property (strong,nonatomic) NSArray *devices;

- (id) initWithDevices:(NSArray *)devices;

@end
