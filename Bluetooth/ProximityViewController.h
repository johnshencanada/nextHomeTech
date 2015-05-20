//
//  ProximityViewController.h
//  nextHome
//
//  Created by john on 5/10/15.
//  Copyright (c) 2015 Banana Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"
#import "CHCircleGaugeView.h"
#import "NYSegmentedControl.h"
#import "VBFPopFlatButton.h"

@interface ProximityViewController : UIViewController <CBPeripheralDelegate>
@property (strong,nonatomic) NSArray *devices;
- (id) initWithDevices:(NSArray *)devices;
@end
