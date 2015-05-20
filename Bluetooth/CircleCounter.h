//
//  CircleCounter.h
//  Color
//
//  Created by nextHome on 7/7/14.
//  Copyright (c) 2014 nextHome Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

// Defaults
#define JWG_CIRCLE_COLOR_DEFAULT [UIColor colorWithRed:239/255.0f green:101/255.0f blue:48/255.0f alpha:1]
#define JWG_CIRCLE_BACKGROUND_COLOR_DEFAULT [UIColor colorWithWhite:.85f alpha:1]
#define JWG_CIRCLE_TIMER_WIDTH 8.0f

@interface CircleCounter : UIView

/// The color of the circle indicating the remaining amount of time - default is JWG_CIRCLE_COLOR_DEFAULT.
@property (nonatomic, strong) UIColor *circleColor;

/// The color of the circle indicating the expired amount of time - default is JWG_CIRCLE_BACKGROUND_COLOR_DEFAULT.
@property (nonatomic, strong) UIColor *circleBackgroundColor;

/// The thickness of the circle color - default is JWG_CIRCLE_TIMER_WIDTH.
@property (nonatomic, assign) CGFloat circleWidth;

- (void)setColor:(UIColor *)color;
- (void)start;

- (void)incrementBy:(NSUInteger)amount;

- (void)decrementBy:(NSUInteger)amount;

@end
