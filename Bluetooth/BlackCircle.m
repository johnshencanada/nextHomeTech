//
//  BlackCircle.m
//  nextHome
//
//  Created by john on 4/16/15.
//  Copyright (c) 2015 Banana Technology. All rights reserved.
//

#import "BlackCircle.h"

@implementation BlackCircle

- (void)layoutSubviews
{
    UIView *circle = [[UIView alloc] initWithFrame:self.bounds];
    circle.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    circle.layer.cornerRadius = circle.bounds.size.width/2;
    circle.layer.borderWidth = 0.5f;
    circle.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.1].CGColor;
    [self addSubview:circle];
}

@end
