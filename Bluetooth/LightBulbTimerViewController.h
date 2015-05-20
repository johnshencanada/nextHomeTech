//
//  LightBulbTimerViewController.h
//  nextHome
//
//  Created by john on 8/29/14.
//  Copyright (c) 2014 nextHome Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LightBulbTimerViewController : UICollectionViewController
@property (nonatomic) UIButton *add;
- (id) initWithDevices:(NSArray *)devices;

@end
