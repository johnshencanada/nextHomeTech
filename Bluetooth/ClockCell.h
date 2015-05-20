//
//  ClockCell.h
//  nextHome
//
//  Created by john on 12/18/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMAnalogClockView.h"
#import "CHCircleGaugeView.h"

@interface ClockCell : UICollectionViewCell <BEMAnalogClockDelegate>
@property CGRect screenRect;
@property (strong,nonatomic) UILabel *instruction1;
@property (strong,nonatomic) UILabel *instruction2;

@property (strong,nonatomic) UILabel *alarmLabel;
@property (strong,nonatomic) UILabel *timerLabel;
@property (strong,nonatomic) UILabel *proximityLabel;
@property (strong,nonatomic) UILabel *actionLabel;
@property (strong,nonatomic) UISwitch *enableSwitch;
@property (strong,nonatomic) BEMAnalogClockView *myClock;
@property (nonatomic) CHCircleGaugeView *circleGaugeView;

- (void)setActionLabelName:(NSString*) name;
@end
