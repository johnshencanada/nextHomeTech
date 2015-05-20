//
//  ChildViewController.h
//  nextHome
//
//  Created by john on 12/20/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMAnalogClockView.h"
#import "Device.h"
#import "BEMAnalogClockView.h"
#import "CHCircleGaugeView.h"
#import "NYSegmentedControl.h"
#import "VBFPopFlatButton.h"

@interface ChildViewController : UIViewController <BEMAnalogClockDelegate, UIGestureRecognizerDelegate,CBPeripheralDelegate>
@property (strong,nonatomic) NSArray *devices;
@property (assign, nonatomic) NSInteger index;
@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIView *contentView;
- (id) initWithDevices:(NSArray *)devices;
@end
