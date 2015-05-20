//
//  CircleCounter.m
//  Color
//
//  Created by nextHome on 7/7/14.
//  Copyright (c) 2014 nextHome Technology. All rights reserved.
//

#import "CircleCounter.h"
@interface CircleCounter()
@property (nonatomic) double currentPosition;
@end

@implementation CircleCounter

- (void)setCurrentPosition:(double)currentPosition
{
    _currentPosition = currentPosition;

}

- (void)baseInit {
    self.backgroundColor = [UIColor clearColor];
    self.circleColor = JWG_CIRCLE_COLOR_DEFAULT;
    self.circleBackgroundColor = JWG_CIRCLE_BACKGROUND_COLOR_DEFAULT;
    self.circleWidth = 10.0f;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (void)setColor:(UIColor *)color
{
    self.circleColor = color;
    [self setNeedsDisplay];
}

- (void)start
{
    self.currentPosition = 0.0;
    [self setNeedsDisplay];
}

- (void)incrementBy:(NSUInteger)amount
{
    if (self.currentPosition > 0) {
        self.currentPosition -= 0.02;
//        int i = 100-(int)(self.currentPosition * 100);
        [self setNeedsDisplay];
    }
}

- (void)decrementBy:(NSUInteger)amount
{
    if (self.currentPosition < 1){
        self.currentPosition += 0.02;
//        int i = 100-(int)(self.currentPosition * 100);
        [self setNeedsDisplay];
    }
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    float radius = CGRectGetWidth(rect)/2.0f - self.circleWidth/2.0f;
    float angleOffset = M_PI_2;
    
    // Draw the background of the circle.
    CGContextSetLineWidth(context, self.circleWidth);
    CGContextBeginPath(context);
    CGContextAddArc(context,
                    CGRectGetMidX(rect), CGRectGetMidY(rect),
                    radius,
                    0,
                    2*M_PI,
                    0);
    CGContextSetStrokeColorWithColor(context, [self.circleBackgroundColor CGColor]);
    CGContextStrokePath(context);
    
    // Draw the remaining amount of timer circle.
    CGContextSetLineWidth(context, self.circleWidth);
    CGContextBeginPath(context);
    CGFloat startAngle = ((CGFloat)self.currentPosition*M_PI*2 - angleOffset);
    CGFloat endAngle = 2*M_PI - angleOffset;
    CGContextAddArc(context,
                    CGRectGetMidX(rect), CGRectGetMidY(rect),
                    radius,
                    startAngle,
                    endAngle,
                    0);
    CGContextSetStrokeColorWithColor(context, [self.circleColor CGColor]);
    CGContextStrokePath(context);

//    NSLog(@"%f", self.currentPosition);
}


@end
