//
//  LightBulbColorViewController.h
//  nextHome
//
//  Created by john on 8/4/14.
//  Copyright (c) 2014 Banana Technology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISColorWheel.h"
#import "ASValueTrackingSlider.h"
#import "Device.h"

@interface LightBulbColorViewController : UIViewController <ISColorWheelDelegate,ASValueTrackingSliderDataSource>
{
    ISColorWheel* _colorWheel;
    UISlider* _brightnessSlider;
}

@property (strong,nonatomic) NSArray *devices;

- (id) initWithDevices:(NSArray *)devices;

@end
