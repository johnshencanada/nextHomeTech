//
//  ClockCell.m
//  nextHome
//
//  Created by john on 12/18/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import "ClockCell.h"

@implementation ClockCell

- (instancetype)initWithFrame:(CGRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        self.screenRect = frameRect;
        self.backgroundColor = [UIColor clearColor];
        
        
        //Instruction
//        self.instruction1 = [[UILabel alloc]initWithFrame:CGRectMake(0,
//                                                                     0,
//                                                                     self.screenRect.size.height/3,
//                                                                     self.screenRect.size.height/4)];
//        self.instruction1.textColor = [UIColor lightGrayColor];
//        self.instruction1.textAlignment = NSTextAlignmentCenter;
//        self.instruction1.font = [UIFont fontWithName:@"GillSans-Light" size:15.0];
//        self.instruction1.text = [NSString stringWithFormat:@"Turn:"];
//        [self addSubview:self.instruction1];
        
        self.instruction2 = [[UILabel alloc]initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     self.screenRect.size.width,
                                                                     self.screenRect.size.height/4)];
        self.instruction2.textColor = [UIColor lightGrayColor];
        self.instruction2.textAlignment = NSTextAlignmentCenter;
        self.instruction2.font = [UIFont fontWithName:@"GillSans-Light" size:15.0];
        self.instruction2.text = [NSString stringWithFormat:@"after:"];
        [self addSubview:self.instruction2];
        
        
        //Timer
        self.timerLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.screenRect.size.width/3,
                                                                   0,
                                                                   self.screenRect.size.width/3,
                                                                   self.screenRect.size.height)];
        self.timerLabel.textColor = [UIColor lightGrayColor];
        self.timerLabel.textAlignment = NSTextAlignmentCenter;
        self.timerLabel.font = [UIFont fontWithName:@"GillSans-Light" size:30.0];
        self.timerLabel.text = [NSString stringWithFormat:@"5 Min"];
        
        //Alarm
        self.alarmLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.screenRect.size.width/3,
                                                                   0,
                                                                   self.screenRect.size.width/3,
                                                                   self.screenRect.size.height)];
        self.alarmLabel.textColor = [UIColor lightGrayColor];
        self.alarmLabel.textAlignment = NSTextAlignmentCenter;
        self.alarmLabel.font = [UIFont fontWithName:@"GillSans-Light" size:25.0];
        self.alarmLabel.text = [NSString stringWithFormat:@"8:00 AM"];

        
        //Proximity
        self.proximityLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.screenRect.size.width/2.5,
                                                                       self.screenRect.size.height/4,
                                                                       self.screenRect.size.height/2,
                                                                       self.screenRect.size.height/2)];
        self.proximityLabel.textColor = [UIColor lightGrayColor];
        self.proximityLabel.textAlignment = NSTextAlignmentCenter;
        self.proximityLabel.font = [UIFont fontWithName:@"GillSans-Light" size:10.0];        
        
        //Action
        self.actionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,
                                                                    self.screenRect.size.height/4,
                                                                    self.screenRect.size.width/3.5,
                                                                    self.screenRect.size.height/2)];
        self.actionLabel.textColor = [UIColor lightGrayColor];
        self.actionLabel.textAlignment = NSTextAlignmentCenter;
        self.actionLabel.font = [UIFont fontWithName:@"GillSans" size:20.0];
        self.actionLabel.text = [NSString stringWithFormat:@"Turn On"];
        [self addSubview:self.actionLabel];
        
        
        //Switch
        self.enableSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(250, 50, 60, 30)];
        self.enableSwitch.tintColor = [UIColor colorWithWhite:1 alpha:0.1];
        self.enableSwitch.onTintColor = [UIColor colorWithRed:(114/255.0) green:(203/255.0) blue:(208/255.0) alpha:0.4];
        self.enableSwitch.on = YES;
        [self addSubview:self.enableSwitch];
    }
    return self;
}

- (void)setActionLabelName:(NSString*)name
{
    if ([name isEqualToString:@"alarm"]) {
        [self.timerLabel removeFromSuperview];
        [self.proximityLabel removeFromSuperview];
        [self.myClock removeFromSuperview];
        [self.circleGaugeView removeFromSuperview];
        self.instruction2.center = CGPointMake(self.screenRect.size.width/2,  self.screenRect.size.height/3.5);
        self.instruction2.text = @"at:";

//        self.myClock = [[BEMAnalogClockView alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
//        self.myClock.delegate = self;
//        
//        /* Color */
//        self.myClock.faceBackgroundColor = [UIColor clearColor];
//        self.myClock.borderAlpha = 0.7;
//        self.myClock.enableGraduations = NO;
//        self.myClock.enableShadows = NO;
//        
//        /* Size */
//        self.myClock.hourHandWidth = 1.5;
//        self.myClock.hourHandLength = 1;
//        self.myClock.minuteHandWidth = 1;
//        self.myClock.minuteHandLength = 1.0;
//        self.myClock.secondHandWidth = 0.5;
//        self.myClock.secondHandLength = 1;
//        [self addSubview:self.myClock];
        [self addSubview:self.alarmLabel];
    }
    
    else if ([name isEqualToString:@"timer"]) {

        [self.proximityLabel removeFromSuperview];
        [self.circleGaugeView removeFromSuperview];
        [self.myClock removeFromSuperview];
        [self.alarmLabel removeFromSuperview];
        [self addSubview:self.timerLabel];
        
        self.instruction2.text = @"after:";
        self.instruction2.center = CGPointMake(self.screenRect.size.width/2,  self.screenRect.size.height/3.5);
    }
    
    else {
        [self.timerLabel removeFromSuperview];
        [self.myClock removeFromSuperview];
        [self.alarmLabel removeFromSuperview];
        [self.circleGaugeView removeFromSuperview];
        
        self.instruction2.text = @"when signal is:";
        self.instruction2.center = CGPointMake(self.screenRect.size.width/2,  self.screenRect.size.height/5.5);

        self.circleGaugeView = [[CHCircleGaugeView alloc] initWithFrame:CGRectMake(self.screenRect.size.width/2.5,
                                                                                   self.screenRect.size.height/4,
                                                                                   self.screenRect.size.height/2.5,
                                                                                   self.screenRect.size.height/2.5)];
        self.circleGaugeView.center = CGPointMake(self.screenRect.size.width/2,  self.screenRect.size.height/2);
        self.circleGaugeView.state = CHCircleGaugeViewStatePercentSign;

        /* Color */
        self.circleGaugeView.trackTintColor = [UIColor colorWithWhite:255 alpha:0.1];
        self.circleGaugeView.gaugeTintColor = [UIColor colorWithRed:0.298 green:0.851 blue:0.392 alpha:0.8];
        self.circleGaugeView.textColor = [UIColor clearColor];
        self.circleGaugeView.font = [UIFont fontWithName:@"GillSans" size:5.0];
        
        /* Size */
        self.circleGaugeView.trackWidth = 6;
        self.circleGaugeView.gaugeWidth = 3;
        [self.circleGaugeView setValue:0.9 animated:YES];
        [self addSubview:self.circleGaugeView];
        [self addSubview:self.proximityLabel];
    }
    
}

@end
