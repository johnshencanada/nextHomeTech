//
//  BrightnessView.m
//  nextHome
//
//  Created by john on 8/15/14.
//  Copyright (c) 2014 nextHome Technology. All rights reserved.
// 

#import "BrightnessView.h"

@implementation BrightnessView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.height = 1150.0;
        self.color = [UIColor whiteColor];
    }
    return self;
}

/* Increment the height when swiped upwards */
- (void)increaseHeight {
    if (self.height <= 1150.0) {
        self.height += 20.0;
        [self setNeedsDisplay];
    }
}

/* Decrement the height when swiped downwards */
- (void)decreaseHeight {
    if (self.height > 20.0) {
        self.height -= 20.0;
        [self setNeedsDisplay];
    }
}

/* The Detail VC is going to set a delegation in Color VC, so when the color is changed, the color of this view changes */
- (void)changeColor:(UIColor *)color
{
    
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextFillRect(context, self.bounds);
    [self drawRectangle];
}

- (void)drawRectangle
{
    CGPoint center = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height/2);
    float rectangleWidth = 320;
    float rectangleHeight = self.height;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextAddRect(ctx, CGRectMake(center.x - (0.5 * rectangleWidth), center.y - (0.5 * rectangleHeight), rectangleWidth, rectangleHeight));
    CGContextStrokePath(ctx);
    
    CGContextSetFillColorWithColor(ctx, [self.color CGColor]);
    CGContextAddRect(ctx, CGRectMake(center.x - (0.5 * rectangleWidth), center.y - (0.5 * rectangleHeight), rectangleWidth, rectangleHeight));
    CGContextFillPath(ctx);
}
@end
