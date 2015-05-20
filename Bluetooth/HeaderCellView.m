//
//  HeaderCellView.m
//  nextHome
//
//  Created by john on 8/23/14.
//  Copyright (c) 2014 nextHome Technology. All rights reserved.
//

#import "HeaderCellView.h"

@implementation HeaderCellView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.category = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
        self.category.text = [NSString stringWithFormat:@"Rooms"];
        self.category.textAlignment = NSTextAlignmentLeft;
        self.category.font = [UIFont fontWithName:@"GillSans-Light" size:15.0];
        self.category.textColor = [UIColor whiteColor];
        [self addSubview:self.category];
    }
    return self;
}

@end
