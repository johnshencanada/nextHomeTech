//
//  TimedActionCollectionViewController.h
//  nextHome
//
//  Created by john on 12/18/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"

@interface TimedActionCollectionViewController : UICollectionViewController
@property (strong,nonatomic) NSArray *devices;
- (id) initWithDevices:(NSArray *)devices;
@end
