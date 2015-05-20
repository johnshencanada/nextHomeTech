//
//  BrightnessView.h
//  nextHome
//
//  Created by john on 8/15/14.
//  Copyright (c) 2014 nextHome Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrightnessView : UIView

@property double height;
@property UIColor *color;

- (void)increaseHeight;
- (void)decreaseHeight;

@end
